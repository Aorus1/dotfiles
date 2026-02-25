# LazyVim IDE Setup Design

**Date:** 2026-02-25
**Status:** Approved

## Overview

Replace the current minimal `config/nvim/init.lua` with a full LazyVim IDE setup using the official starter template structure. Configured for Python, Rust, C/C++, Java, JS/TS, and TeX development.

## File Structure

```
config/nvim/
├── init.lua                  # LazyVim bootstrap + extras list
├── lazy-lock.json            # (gitignored — machine-specific)
└── lua/
    ├── config/
    │   ├── options.lua       # Overrides/additions to LazyVim defaults
    │   ├── keymaps.lua       # Custom keymaps
    │   └── autocmds.lua      # Auto-commands
    └── plugins/
        ├── colorscheme.lua   # Catppuccin + light/dark toggle
        ├── treesitter.lua    # Extra language parsers
        └── cheatsheet.lua    # Custom cheatsheet popup
```

LazyVim auto-loads all files in `lua/config/` and `lua/plugins/` — new plugins are added by dropping a file in `lua/plugins/`.

## Language Extras

Enabled via LazyVim's extras system in `init.lua`:

| Extra | Language | LSP | Formatter/Linter |
|---|---|---|---|
| `lang.python` | Python | Pyright | Ruff |
| `lang.rust` | Rust | rust-analyzer | rustfmt (via rustaceanvim) |
| `lang.clangd` | C/C++ | clangd | clang-format |
| `lang.java` | Java | jdtls | - |
| `lang.typescript` | JS/TS | ts_ls | Prettier, ESLint |
| `lang.tex` | TeX/LaTeX | texlab | - (VimTeX) |

Mason auto-installs all language servers on first launch.

## Colorscheme

**Plugin:** Catppuccin
**Default:** Mocha (dark, pink/mauve accents)
**Light variant:** Latte
**Toggle:** `<leader>tt` — switches between Mocha and Latte, persisted across restarts via a state file at `~/.local/share/nvim/catppuccin-flavor`

LazyVim's default Tokyo Night colorscheme is disabled.

## File Browser

**Plugin:** neo-tree (included with LazyVim)

| Key | Action |
|---|---|
| `<leader>e` | Toggle sidebar |
| `<leader>E` | Open sidebar focused on current file |

## Cheatsheet

Custom floating popup bound to `<leader>ch`. Shows all key bindings grouped by category (navigation, LSP, git, file, etc.), styled with Catppuccin colors.

## Key Bindings Reference

### LazyVim Defaults (unchanged)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>e` | File browser |
| `<leader>E` | File browser (current file) |
| `gd` | Go to definition |
| `gr` | Find references |
| `<leader>cr` | Rename symbol |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| `H` / `L` | Previous/next buffer |
| `<leader>ft` | Terminal |
| `<leader>gg` | Lazygit |
| `<leader>?` | Which-key buffer keymaps |
| `<leader>sk` | Search keymaps |

### Custom Keymaps

| Key | Action |
|---|---|
| `<leader>tt` | Toggle Catppuccin Mocha ↔ Latte |
| `<leader>ch` | Open cheatsheet popup |

## Documentation

`docs/NVIM.md` in the dotfiles repo — human-readable reference of all keybinds (defaults + custom), updated as new plugins are added.
