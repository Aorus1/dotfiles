# Dotfiles Setup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a personal dotfiles repo with starter configs for zsh, nvim, tmux, and wezterm, deployed via a simple idempotent install script.

**Architecture:** Plain git repo at `~/.dotfiles/`. Configs live in `config/` mirroring `~/.config/`. A shell script symlinks them into place. Only `~/.zshenv` lands in `~/`; everything else goes under `~/.config/`.

**Tech Stack:** bash (install script), zsh, Lua (nvim/wezterm config), Homebrew (Brewfile)

---

### Task 1: Create directory structure

**Files:**
- Create: `config/zsh/` (directory)
- Create: `config/nvim/lua/` (directory)
- Create: `config/tmux/` (directory)
- Create: `config/wezterm/` (directory)

**Step 1: Create all config directories**

```bash
mkdir -p ~/.dotfiles/config/zsh
mkdir -p ~/.dotfiles/config/nvim/lua
mkdir -p ~/.dotfiles/config/tmux
mkdir -p ~/.dotfiles/config/wezterm
```

**Step 2: Verify structure**

```bash
find ~/.dotfiles/config -type d
```

Expected output:
```
/Users/maya/.dotfiles/config
/Users/maya/.dotfiles/config/zsh
/Users/maya/.dotfiles/config/nvim
/Users/maya/.dotfiles/config/nvim/lua
/Users/maya/.dotfiles/config/tmux
/Users/maya/.dotfiles/config/wezterm
```

**Step 3: Commit**

```bash
cd ~/.dotfiles
git add config/
git commit -m "feat: scaffold config directory structure"
```

---

### Task 2: Write install.sh

**Files:**
- Create: `install.sh`

**Step 1: Write the script**

```bash
cat > ~/.dotfiles/install.sh << 'EOF'
#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

backup_and_link() {
  local src="$1"
  local dst="$2"

  # If dst is already the correct symlink, skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  [skip] $dst already linked"
    return
  fi

  # Backup existing real file or dir
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "  [backup] $dst → $bak"
    mv "$dst" "$bak"
  fi

  # Remove stale symlink
  if [ -L "$dst" ]; then
    rm "$dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "  [link] $dst → $src"
}

echo "==> Creating symlinks..."
backup_and_link "$DOTFILES/config/zsh"        "$CONFIG/zsh"
backup_and_link "$DOTFILES/config/zsh/.zshenv" "$HOME/.zshenv"
backup_and_link "$DOTFILES/config/nvim"        "$CONFIG/nvim"
backup_and_link "$DOTFILES/config/tmux"        "$CONFIG/tmux"
backup_and_link "$DOTFILES/config/wezterm"     "$CONFIG/wezterm"

echo ""
read -p "==> Install Homebrew packages from Brewfile? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  brew bundle --file "$DOTFILES/Brewfile"
fi

echo ""
echo "Done. Open a new terminal to load your shell config."
EOF
chmod +x ~/.dotfiles/install.sh
```

**Step 2: Verify it's executable**

```bash
ls -la ~/.dotfiles/install.sh
```

Expected: `-rwxr-xr-x` permissions.

**Step 3: Dry-run check (don't run yet — configs don't exist)**

```bash
bash -n ~/.dotfiles/install.sh
```

Expected: no output (syntax is valid).

**Step 4: Commit**

```bash
cd ~/.dotfiles
git add install.sh
git commit -m "feat: add idempotent install script"
```

---

### Task 3: Write zsh config

**Files:**
- Create: `config/zsh/.zshenv`
- Create: `config/zsh/.zprofile`
- Create: `config/zsh/.zshrc`

**Step 1: Write .zshenv** (bootstraps XDG vars and tells zsh where to find the rest)

```bash
cat > ~/.dotfiles/config/zsh/.zshenv << 'EOF'
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
EOF
```

**Step 2: Write .zprofile** (login shell: PATH setup)

```bash
cat > ~/.dotfiles/config/zsh/.zprofile << 'EOF'
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
EOF
```

**Step 3: Write .zshrc** (interactive shell: aliases, options, tools)

```bash
cat > ~/.dotfiles/config/zsh/.zshrc << 'EOF'
# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

# History
export HISTFILE="$XDG_DATA_HOME/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
alias d="dirs -v | head -n 10"

# Completion
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -U compinit; compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
_comp_options+=(globdots)

# Vim mode
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward

# Aliases — navigation
alias ..="cd .."
alias ...="cd ../.."
alias l="ls"
alias la="ls -ltra"

# Aliases — editor
alias vi="nvim"
alias vim="nvim"
alias vizshrc="nvim $ZDOTDIR/.zshrc"
alias rlzshrc="source $ZDOTDIR/.zshrc"

# Aliases — git
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"
alias gl="git log"
alias glo="git log --pretty=oneline"
alias glol="git log --graph --oneline --decorate"

# PATH additions (add your own below)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fnm (node version manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# opam (OCaml)
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
EOF
```

**Step 4: Verify files exist**

```bash
ls -la ~/.dotfiles/config/zsh/
```

Expected: `.zshenv`, `.zprofile`, `.zshrc`

**Step 5: Commit**

```bash
cd ~/.dotfiles
git add config/zsh/
git commit -m "feat: add starter zsh config"
```

---

### Task 4: Write nvim config

**Files:**
- Create: `config/nvim/init.lua`

**Step 1: Write init.lua** (minimal starter — just options, no plugins yet)

```bash
cat > ~/.dotfiles/config/nvim/init.lua << 'EOF'
-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 100
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Stay in indent mode
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

-- NOTE: Add plugins here later (e.g. lazy.nvim)
EOF
```

**Step 2: Verify**

```bash
cat ~/.dotfiles/config/nvim/init.lua | head -5
```

Expected: starts with `-- Options`

**Step 3: Commit**

```bash
cd ~/.dotfiles
git add config/nvim/
git commit -m "feat: add minimal starter nvim config"
```

---

### Task 5: Write tmux config

**Files:**
- Create: `config/tmux/tmux.conf`

**Step 1: Write tmux.conf**

```bash
cat > ~/.dotfiles/config/tmux/tmux.conf << 'EOF'
# General
set -g mouse on
set -g focus-events on
set -sg escape-time 10
set -ga terminal-overrides ",xterm-256color:Tc"
set -g base-index 1
set -g pane-base-index 1

# Status bar
set -g status-position bottom
set -g status-justify left
set -g status-right ' %m/%d/%y %H:%M '
set -g status-style bg=default

# Vim-style pane navigation
bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R

# Splits that open in current directory
bind '"' split-window -v -c "#{pane_current_path}"
bind '%' split-window -h -c "#{pane_current_path}"

# Kill pane without confirmation
bind x kill-pane
EOF
```

**Step 2: Commit**

```bash
cd ~/.dotfiles
git add config/tmux/
git commit -m "feat: add starter tmux config"
```

---

### Task 6: Write wezterm config

**Files:**
- Create: `config/wezterm/wezterm.lua`

**Step 1: Write wezterm.lua** (minimal — no colorscheme set so you can pick your own)

```bash
cat > ~/.dotfiles/config/wezterm/wezterm.lua << 'EOF'
local wezterm = require 'wezterm'
local config = {}

-- Font (requires a Nerd Font installed — install via: brew install --cask font-hack-nerd-font)
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 16

-- Padding
config.window_padding = {
  left = 15,
  right = 15,
  top = 35,  -- extra room for MacBook notch
  bottom = 0,
}

-- Window
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'

-- Tab bar (disabled — use tmux instead)
config.enable_tab_bar = false

-- Misc
config.audible_bell = "Disabled"

-- Keymaps
config.keys = {
  { key = 'f', mods = 'SUPER|SHIFT', action = wezterm.action.ToggleFullScreen },
  { key = '+', mods = 'SUPER',       action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'SUPER',       action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'SUPER',       action = wezterm.action.ResetFontSize },
  -- Pane splits
  { key = 'd', mods = 'SUPER',       action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'SUPER',       action = wezterm.action.CloseCurrentPane { confirm = false } },
}

return config
EOF
```

**Step 2: Commit**

```bash
cd ~/.dotfiles
git add config/wezterm/
git commit -m "feat: add starter wezterm config"
```

---

### Task 7: Write Brewfile

**Files:**
- Create: `Brewfile`

**Step 1: Generate from current installs and clean it up**

```bash
brew bundle dump --force --file ~/.dotfiles/Brewfile
```

This captures every currently installed formula, cask, and tap. Open the file and trim anything you don't want to carry to a new machine.

**Step 2: Verify it contains the core tools**

```bash
grep -E "neovim|tmux|wezterm|zoxide|fnm|git" ~/.dotfiles/Brewfile
```

Expected: each tool appears at least once.

**Step 3: Commit**

```bash
cd ~/.dotfiles
git add Brewfile
git commit -m "feat: add Brewfile with current package list"
```

---

### Task 8: Write README

**Files:**
- Create: `README.md`

**Step 1: Write README.md**

```bash
cat > ~/.dotfiles/README.md << 'EOF'
# dotfiles

Personal config for zsh, nvim, tmux, and wezterm on macOS.

## Setup

```sh
git clone <your-repo-url> ~/.dotfiles
~/.dotfiles/install.sh
```

Then open a new terminal.

## Update Brewfile

```sh
brew bundle dump --force --file ~/.dotfiles/Brewfile
```

## Structure

```
config/
├── zsh/        → ~/.config/zsh  (+ ~/.zshenv)
├── nvim/       → ~/.config/nvim
├── tmux/       → ~/.config/tmux
└── wezterm/    → ~/.config/wezterm
```
EOF
```

**Step 2: Commit**

```bash
cd ~/.dotfiles
git add README.md
git commit -m "docs: add README with setup instructions"
```

---

### Task 9: Run install.sh and verify

**Step 1: Run the install script**

```bash
~/.dotfiles/install.sh
```

Expected: symlinks created for all five targets, no errors. Answer `n` to Brewfile install (already installed).

**Step 2: Verify symlinks**

```bash
ls -la ~/.config/zsh ~/.config/nvim ~/.config/tmux ~/.config/wezterm ~/.zshenv
```

Expected: each is a symlink (`l` in `ls` output) pointing into `~/.dotfiles/config/`.

**Step 3: Verify zsh loads correctly**

```bash
zsh -l -c "echo ok"
```

Expected: `ok` (no errors).

**Step 4: Open a new terminal and verify**

Open a new WezTerm window and run:
```sh
echo $ZDOTDIR    # should print ~/.config/zsh
echo $EDITOR     # should print nvim
which zoxide     # should find it
```

**Step 5: Re-run install.sh to verify idempotency**

```bash
~/.dotfiles/install.sh
```

Expected: all lines say `[skip]` — nothing is re-linked or backed up.
