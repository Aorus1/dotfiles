local wezterm = require 'wezterm'
local config = {}

-- Font (requires a Nerd Font installed — install via: brew install --cask font-hack-nerd-font)
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 16

-- Padding
config.window_padding = {
  left = 15,
  right = 15,
  top = 35,  -- extra room for MacBook notch
  bottom = 0,
}

-- Window
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'

-- Tab bar (disabled — use tmux instead)
config.enable_tab_bar = false

-- Misc
config.audible_bell = "Disabled"

-- Keymaps
config.keys = {
  { key = 'f', mods = 'SUPER|SHIFT', action = wezterm.action.ToggleFullScreen },
  { key = '+', mods = 'SUPER',       action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'SUPER',       action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'SUPER',       action = wezterm.action.ResetFontSize },
  -- Pane splits
  { key = 'd', mods = 'SUPER',       action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'SUPER',       action = wezterm.action.CloseCurrentPane { confirm = false } },
}

return config
