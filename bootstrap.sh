#!/usr/bin/env bash
set -e

echo "[1/4] Installing required Homebrew packages..."
brew install stow git neovim tmux node lua-language-server llvm

echo "[2/4] Installing fonts..."
brew tap homebrew/cask-fonts || true
brew install --cask font-hack-nerd-font || true

echo "[3/4] Installing npm language servers..."
cd config/.config
./setup.sh
cd ../..

echo "[4/4] Deploying config with stow..."
stow config

echo "✅ Setup complete. Now open Neovim and run :Lazy install, then :TSUpdate"
