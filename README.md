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
