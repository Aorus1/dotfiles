# LazyVim IDE Setup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the minimal nvim starter with a full LazyVim IDE setup including language servers, Catppuccin theming, file browser, and a cheatsheet popup.

**Architecture:** LazyVim starter template structure — `init.lua` bootstraps lazy.nvim and delegates to `lua/config/lazy.lua` which declares all plugin specs including LazyVim extras. Custom plugins live in `lua/plugins/`, custom options/keymaps in `lua/config/`. Everything is committed to the dotfiles repo at `~/.dotfiles/config/nvim/`, which is symlinked to `~/.config/nvim/`.

**Tech Stack:** Neovim (0.9+), lazy.nvim, LazyVim, Catppuccin, Mason (LSP installer), Tree-sitter

---

### Task 1: Bootstrap LazyVim

**Files:**
- Modify: `config/nvim/init.lua`
- Create: `config/nvim/lua/config/lazy.lua`
- Create: `config/nvim/lua/config/options.lua`
- Create: `config/nvim/lua/config/keymaps.lua`
- Create: `config/nvim/lua/config/autocmds.lua`

**Step 1: Replace init.lua**

The entire content of `config/nvim/init.lua` should be:

```lua
-- Bootstrap lazy.nvim, LazyVim and plugins
require("config.lazy")
```

**Step 2: Create lua/config/lazy.lua**

This bootstraps lazy.nvim (auto-installs it if missing) and declares the full plugin spec including all LazyVim extras:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Language extras
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.tex" },

    -- User plugins (lua/plugins/*.lua)
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
```

**Step 3: Create lua/config/options.lua**

```lua
-- Options are set automatically by LazyVim.
-- Add your overrides here.
local opt = vim.opt

opt.relativenumber = true   -- show relative line numbers
opt.scrolloff = 8           -- keep 8 lines above/below cursor
opt.wrap = false            -- disable line wrap
```

**Step 4: Create lua/config/keymaps.lua**

```lua
-- Keymaps are set automatically by LazyVim.
-- Add your custom keymaps here.
-- (populated in later tasks)
```

**Step 5: Create lua/config/autocmds.lua**

```lua
-- Autocmds are set automatically by LazyVim.
-- Add your custom autocmds here.
```

**Step 6: Verify structure**

```bash
find ~/.dotfiles/config/nvim -type f | sort
```

Expected:
```
~/.dotfiles/config/nvim/init.lua
~/.dotfiles/config/nvim/lua/config/autocmds.lua
~/.dotfiles/config/nvim/lua/config/keymaps.lua
~/.dotfiles/config/nvim/lua/config/lazy.lua
~/.dotfiles/config/nvim/lua/config/options.lua
```

**Step 7: Verify nvim starts without errors**

```bash
nvim --headless "+Lazy! sync" +qa 2>&1 | head -20
```

Expected: lazy.nvim bootstraps and clones itself, then exits. May take 30-60 seconds on first run. No Lua errors.

**Step 8: Commit**

```bash
cd ~/.dotfiles
git add config/nvim/
git commit -m "feat: bootstrap LazyVim with language extras"
```

---

### Task 2: Configure Catppuccin colorscheme with light/dark toggle

**Files:**
- Create: `config/nvim/lua/plugins/colorscheme.lua`
- Modify: `config/nvim/lua/config/keymaps.lua`

**Step 1: Create lua/plugins/colorscheme.lua**

```lua
return {
  -- Disable LazyVim's default colorscheme
  { "folke/tokyonight.nvim", enabled = false },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- default; overridden at startup by persisted flavor
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        neo_tree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        mason = true,
        mini = { enabled = true },
        lsp_saga = false,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      -- Load persisted flavor
      local state_file = vim.fn.stdpath("data") .. "/catppuccin-flavor"
      local f = io.open(state_file, "r")
      if f then
        local flavor = f:read("*l")
        f:close()
        if flavor and flavor ~= "" then
          opts.flavour = flavor
        end
      end

      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Tell LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
```

**Step 2: Add toggle keymap to lua/config/keymaps.lua**

```lua
-- Toggle Catppuccin flavor between mocha (dark) and latte (light)
vim.keymap.set("n", "<leader>tt", function()
  local current = require("catppuccin").options.flavour
  local next = current == "mocha" and "latte" or "mocha"

  -- Persist choice
  local state_file = vim.fn.stdpath("data") .. "/catppuccin-flavor"
  local f = io.open(state_file, "w")
  if f then
    f:write(next)
    f:close()
  end

  require("catppuccin").setup({ flavour = next })
  vim.cmd.colorscheme("catppuccin")
  vim.notify("Catppuccin: " .. next, vim.log.levels.INFO)
end, { desc = "Toggle light/dark theme" })
```

**Step 3: Sync plugins**

Open nvim and run:
```
:Lazy sync
```

Wait for Catppuccin to install. Exit and reopen nvim.

**Step 4: Verify**

- nvim should open with Catppuccin Mocha (dark, pink/purple tones)
- Press `<leader>tt` — should switch to Latte (light)
- Close and reopen nvim — should remember Latte
- Press `<leader>tt` again — should switch back to Mocha

**Step 5: Commit**

```bash
cd ~/.dotfiles
git add config/nvim/
git commit -m "feat: add Catppuccin colorscheme with persistent light/dark toggle"
```

---

### Task 3: Add cheatsheet popup

**Files:**
- Create: `config/nvim/lua/plugins/cheatsheet.lua`
- Modify: `config/nvim/lua/config/keymaps.lua`

**Step 1: Create lua/plugins/cheatsheet.lua**

This implements a floating window cheatsheet — no external plugin needed:

```lua
-- Custom cheatsheet popup (NvChad-style)
-- Opened with <leader>ch, closed with q or <Esc>

local M = {}

local keymaps = {
  { category = "Files", key = "<leader>ff", desc = "Find files" },
  { category = "Files", key = "<leader>fg", desc = "Live grep" },
  { category = "Files", key = "<leader>fr", desc = "Recent files" },
  { category = "Files", key = "<leader>e",  desc = "File browser (sidebar)" },
  { category = "Files", key = "<leader>E",  desc = "File browser (current file)" },

  { category = "Buffers", key = "H",          desc = "Previous buffer" },
  { category = "Buffers", key = "L",          desc = "Next buffer" },
  { category = "Buffers", key = "<leader>bd", desc = "Delete buffer" },
  { category = "Buffers", key = "<leader>bb", desc = "Switch buffer" },

  { category = "LSP", key = "gd",          desc = "Go to definition" },
  { category = "LSP", key = "gr",          desc = "Find references" },
  { category = "LSP", key = "gI",          desc = "Go to implementation" },
  { category = "LSP", key = "gy",          desc = "Go to type definition" },
  { category = "LSP", key = "K",           desc = "Hover docs" },
  { category = "LSP", key = "<leader>cr",  desc = "Rename symbol" },
  { category = "LSP", key = "<leader>ca",  desc = "Code action" },
  { category = "LSP", key = "<leader>cd",  desc = "Line diagnostics" },
  { category = "LSP", key = "]d",          desc = "Next diagnostic" },
  { category = "LSP", key = "[d",          desc = "Prev diagnostic" },

  { category = "Git", key = "<leader>gg",  desc = "Lazygit" },
  { category = "Git", key = "<leader>gb",  desc = "Git blame line" },
  { category = "Git", key = "]h",          desc = "Next hunk" },
  { category = "Git", key = "[h",          desc = "Prev hunk" },

  { category = "UI", key = "<leader>tt", desc = "Toggle light/dark theme" },
  { category = "UI", key = "<leader>ch", desc = "Open cheatsheet" },
  { category = "UI", key = "<leader>ft", desc = "Terminal" },
  { category = "UI", key = "<leader>xl", desc = "Location list" },
  { category = "UI", key = "<leader>xq", desc = "Quickfix list" },

  { category = "Windows", key = "<C-h>", desc = "Focus left window" },
  { category = "Windows", key = "<C-j>", desc = "Focus lower window" },
  { category = "Windows", key = "<C-k>", desc = "Focus upper window" },
  { category = "Windows", key = "<C-l>", desc = "Focus right window" },
  { category = "Windows", key = "<leader>|", desc = "Split vertical" },
  { category = "Windows", key = "<leader>-", desc = "Split horizontal" },
}

function M.open()
  -- Build lines grouped by category
  local lines = {}
  local col_width = 20
  local current_cat = nil

  for _, km in ipairs(keymaps) do
    if km.category ~= current_cat then
      if current_cat then
        table.insert(lines, "")
      end
      table.insert(lines, "  " .. km.category)
      table.insert(lines, "  " .. string.rep("─", 36))
      current_cat = km.category
    end
    local key_padded = km.key .. string.rep(" ", col_width - #km.key)
    table.insert(lines, "  " .. key_padded .. "  " .. km.desc)
  end

  -- Compute window size
  local width = 50
  local height = math.min(#lines + 2, vim.o.lines - 4)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("filetype", "cheatsheet", { buf = buf })

  -- Open floating window centered
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
  })

  vim.api.nvim_set_option_value("winhl", "Normal:Normal,FloatBorder:FloatBorder", { win = win })
  vim.api.nvim_set_option_value("cursorline", true, { win = win })

  -- Close on q or Esc
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
  end
end

return {
  -- No external plugin needed — register the open function and keymap
  {
    "LazyVim/LazyVim",
    init = function()
      -- Make M available globally for the keymap
      _G._cheatsheet = M
    end,
  },
}
```

**Step 2: Add cheatsheet keymap to lua/config/keymaps.lua**

Add this below the existing toggle keymap:

```lua
-- Open cheatsheet
vim.keymap.set("n", "<leader>ch", function()
  _G._cheatsheet.open()
end, { desc = "Open cheatsheet" })
```

**Step 3: Verify**

Open nvim and press `<leader>ch`. Expected: a centered floating window with grouped keybinds appears. Press `q` or `<Esc>` to close.

**Step 4: Commit**

```bash
cd ~/.dotfiles
git add config/nvim/
git commit -m "feat: add cheatsheet popup (<leader>ch)"
```

---

### Task 4: Write NVIM.md documentation

**Files:**
- Create: `docs/NVIM.md`

**Step 1: Write docs/NVIM.md**

```markdown
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
| `<C-h/j/k/l>` | Move between windows |
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
```

**Step 2: Commit**

```bash
cd ~/.dotfiles
git add docs/NVIM.md
git commit -m "docs: add NVIM.md keybind reference"
```

---

### Task 5: Final verification

**Step 1: Open nvim and confirm LazyVim loaded**

```bash
nvim
```

Expected:
- No errors on startup
- Catppuccin Mocha theme active (dark, pink/purple)
- Status line visible at bottom (lualine)
- Which-key popup available (press `<leader>` and wait)

**Step 2: Verify file browser**

Press `<leader>e` — neo-tree sidebar should open on the left.

**Step 3: Verify LSP installation**

Run `:Mason` — should show installed LSPs for all languages. If any are missing, run `:MasonInstall pyright rust-analyzer clangd jdtls typescript-language-server texlab`.

**Step 4: Verify cheatsheet**

Press `<leader>ch` — cheatsheet popup should appear. Press `q` to close.

**Step 5: Verify theme toggle**

Press `<leader>tt` — should switch to Latte (light). Close and reopen nvim — Latte should persist. Press `<leader>tt` again — Mocha restored.

**Step 6: Check health**

Run `:checkhealth` — address any warnings about missing system dependencies (e.g. `fd`, `ripgrep`). Both are in the Brewfile so should already be installed.
