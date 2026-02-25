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
        local valid = { mocha = true, latte = true, frappe = true, macchiato = true }
        if flavor and valid[flavor] then
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
