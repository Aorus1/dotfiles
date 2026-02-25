-- Toggle Catppuccin flavor between mocha (dark) and latte (light)
vim.keymap.set("n", "<leader>tt", function()
  local current = require("catppuccin").options.flavour
  local next_flavor = current == "mocha" and "latte" or "mocha"

  -- Persist choice
  local state_file = vim.fn.stdpath("data") .. "/catppuccin-flavor"
  local f = io.open(state_file, "w")
  if f then
    f:write(next_flavor)
    f:close()
  end

  require("catppuccin").setup({ flavour = next_flavor })
  vim.cmd.colorscheme("catppuccin")
  vim.notify("Catppuccin: " .. next_flavor, vim.log.levels.INFO)
end, { desc = "Toggle light/dark theme" })
