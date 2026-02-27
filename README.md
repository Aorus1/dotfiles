# dotfiles

Personal config for zsh, nvim, tmux, and wezterm. Works on macOS and Linux.

## Setup — macOS

```sh
git clone <your-repo-url> ~/.dotfiles
~/.dotfiles/install.sh
```

Then open a new terminal.

## Setup — Linux

**1. Install system dependencies**

Debian/Ubuntu:
```sh
sudo apt install zsh git curl build-essential unzip
```

Arch:
```sh
sudo pacman -S zsh git curl base-devel unzip
```

**2. Install Homebrew**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**3. Install WezTerm**

Not in the Brewfile on Linux — install from your package manager or from the WezTerm website.

**4. Install Hack Nerd Font**

Download from nerdfonts.com, extract to `~/.local/share/fonts/`, then run:
```sh
fc-cache -fv
```

**5. Install a JDK** (only needed for Java LSP)

Debian/Ubuntu: `sudo apt install default-jdk`
Arch: `sudo pacman -S jdk-openjdk`

**6. Set zsh as your default shell**

```sh
chsh -s $(which zsh)
```

**7. Clone and run**

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
