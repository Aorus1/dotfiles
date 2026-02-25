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
