# Neovim Keybind Reference

Leader key: `<Space>`

## Files & Search

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text) |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle file browser sidebar |
| `<leader>E` | File browser focused on current file |

## Buffers & Windows

| Key | Action |
|---|---|
| `H` | Previous buffer |
| `L` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bb` | Switch buffer |
| `<C-h>` | Focus left window |
| `<C-j>` | Focus lower window |
| `<C-k>` | Focus upper window |
| `<C-l>` | Focus right window |
| `<leader>\|` | Split vertical |
| `<leader>-` | Split horizontal |

## LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |

## Git

| Key | Action |
|---|---|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Git blame current line |
| `]h` / `[h` | Next/prev git hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |

## UI & Tools

| Key | Action |
|---|---|
| `<leader>ch` | Open cheatsheet |
| `<leader>tt` | Toggle light/dark theme (Mocha ↔ Latte) |
| `<leader>ft` | Open terminal |
| `<leader>?` | Which-key: show all buffer keymaps |
| `<leader>sk` | Search all keymaps |

## Adding a New Language

1. Find the LazyVim extra: https://www.lazyvim.org/extras
2. Add `{ import = "lazyvim.plugins.extras.lang.<name>" }` to `lua/config/lazy.lua`
3. Open nvim → `:Lazy sync` → Mason auto-installs the LSP

## Adding a New Plugin

Create a new file in `lua/plugins/<name>.lua` returning a lazy.nvim plugin spec:

```lua
return {
  "author/plugin-name",
  opts = {},
}
```
