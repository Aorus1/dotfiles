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
  { category = "Git", key = "<leader>ghs", desc = "Stage hunk" },
  { category = "Git", key = "<leader>ghr", desc = "Reset hunk" },
  { category = "Git", key = "]h",          desc = "Next hunk" },
  { category = "Git", key = "[h",          desc = "Prev hunk" },

  { category = "UI", key = "<leader>tt", desc = "Toggle light/dark theme" },
  { category = "UI", key = "<leader>ch", desc = "Open cheatsheet" },
  { category = "UI", key = "<leader>ft", desc = "Terminal" },
  { category = "UI", key = "<leader>xl", desc = "Location list" },
  { category = "UI", key = "<leader>xq", desc = "Quickfix list" },

  { category = "Windows", key = "<C-h>",     desc = "Focus left window" },
  { category = "Windows", key = "<C-j>",     desc = "Focus lower window" },
  { category = "Windows", key = "<C-k>",     desc = "Focus upper window" },
  { category = "Windows", key = "<C-l>",     desc = "Focus right window" },
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
    local key_padded = km.key .. string.rep(" ", math.max(0, col_width - #km.key))
    table.insert(lines, "  " .. key_padded .. "  " .. km.desc)
  end

  -- Compute window size
  local width = 50
  local height = math.min(#lines + 2, vim.o.lines - 4)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
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
  -- No external plugin needed — register the open function globally for the keymap
  {
    "LazyVim/LazyVim",
    init = function()
      _G._cheatsheet = M
    end,
  },
}
