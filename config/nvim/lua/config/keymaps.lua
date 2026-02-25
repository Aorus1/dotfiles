-- Toggle Catppuccin flavor between mocha (dark) and latte (light)
vim.keymap.set("n", "<leader>tt", function()
  local state_file = vim.fn.stdpath("data") .. "/catppuccin-flavor"

  -- Read current flavor from state file (single source of truth)
  local rf = io.open(state_file, "r")
  local current = rf and rf:read("*l") or "mocha"
  if rf then rf:close() end

  local next_flavor = current == "mocha" and "latte" or "mocha"

  -- Persist choice, warn if write fails
  local wf, err = io.open(state_file, "w")
  if wf then
    wf:write(next_flavor)
    wf:close()
  else
    vim.notify("Catppuccin: could not persist flavor (" .. (err or "unknown") .. ")", vim.log.levels.WARN)
  end

  require("catppuccin").setup({ flavour = next_flavor })
  vim.cmd.colorscheme("catppuccin")
  vim.notify("Catppuccin: " .. next_flavor, vim.log.levels.INFO)
end, { desc = "Toggle light/dark theme" })

-- Open cheatsheet
vim.keymap.set("n", "<leader>ch", function()
  if _G._cheatsheet then
    _G._cheatsheet.open()
  end
end, { desc = "Open cheatsheet" })
