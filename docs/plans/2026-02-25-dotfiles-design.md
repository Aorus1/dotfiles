# Dotfiles Design

**Date:** 2026-02-25
**Status:** Approved

## Overview

A personal dotfiles repo managing shell and editor configs for macOS, tracked in git, with a simple install script for portability across machines.

## Tools Managed

- **zsh** — shell config (aliases, PATH, options)
- **neovim** — editor config
- **tmux** — terminal multiplexer config
- **wezterm** — terminal emulator config
- **Homebrew** — package list via Brewfile

## Repository Structure

```
~/.dotfiles/
├── install.sh          # creates symlinks + optionally installs Brewfile
├── Brewfile            # all Homebrew packages
├── docs/
│   └── plans/          # design and implementation docs
└── config/
    ├── zsh/
    │   ├── .zshenv     # bootstraps XDG vars and ZDOTDIR
    │   ├── .zprofile   # Homebrew PATH, OrbStack
    │   └── .zshrc      # aliases, options, PATH additions
    ├── nvim/           # full nvim config dir
    ├── tmux/
    │   └── tmux.conf
    └── wezterm/
        └── wezterm.lua
```

## Symlink Mapping

| Repo path | Symlink target |
|---|---|
| `config/zsh/` | `~/.config/zsh` |
| `config/zsh/.zshenv` | `~/.zshenv` |
| `config/nvim/` | `~/.config/nvim` |
| `config/tmux/` | `~/.config/tmux` |
| `config/wezterm/` | `~/.config/wezterm` |

`~/.zshenv` is the only file symlinked directly into `~/`. It sets `ZDOTDIR=~/.config/zsh` so zsh loads the rest of the config from `~/.config/zsh/`.

## install.sh Behavior

1. Creates `~/.config/` if it doesn't exist
2. For each symlink target: backs up any existing real file/dir with a `.bak.<timestamp>` suffix before replacing
3. Creates all symlinks listed above
4. Prompts whether to run `brew bundle` to install the Brewfile
5. Idempotent — safe to re-run

## Brewfile

Pre-populated with: `git`, `neovim`, `tmux`, `wezterm`, `zoxide`, `fnm`.
Update anytime with: `brew bundle dump --force --file ~/.dotfiles/Brewfile`

## New Machine Setup

```sh
git clone <repo-url> ~/.dotfiles
~/.dotfiles/install.sh
```
