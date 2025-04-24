local wezterm = require 'wezterm'
local config = {}

-- Display
config.color_scheme = 'Everblush'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 16
config.window_padding = {
    left = 15,
    right = 15,
    top = 35, -- Large because of the location of the MBP camera.
    bottom = 0
}

-- Windows --
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.window_background_opacity = 0.9

-- Functionality --
config.enable_tab_bar = false
config.audible_bell = "Disabled"

-- Keymaps --
config.keys = {
    -- Display Bindings --
    {
        key     = 'f',
        mods    = 'SUPER|SHIFT',
        action  = wezterm.action.ToggleFullScreen
    },
    {
        key     = '+',
        mods    = 'SUPER',
        action  = wezterm.action.IncreaseFontSize
    },
    {
        key     = '-',
        mods    = 'SUPER',
        action  = wezterm.action.DecreaseFontSize
    },
    {
        key     = '0',
        mods    = 'SUPER',
        action  = wezterm.action.ResetFontSize
    },
    -- Pane Bindings  --
    {
        key     = 'Enter',
        mods    = 'SUPER|SHIFT',
        action  = wezterm.action.TogglePaneZoomState
    },
    {
        key     = 'd',
        mods    = 'SUPER',
        action  = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
        key     = 'd',
        mods    = 'SUPER|SHIFT',
        action  = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key     = 'w',
        mods    = 'SUPER',
        action  = wezterm.action.CloseCurrentPane { confirm = false }
    },
    {
        key     = 'LeftArrow',
        mods    = 'SUPER',
        action  = wezterm.action.ActivatePaneDirection 'Left'
    },
    {
        key     = 'RightArrow',
        mods    = 'SUPER',
        action  = wezterm.action.ActivatePaneDirection 'Right'
    },
    {
        key     = 'UpArrow',
        mods    = 'SUPER',
        action  = wezterm.action.ActivatePaneDirection 'Up'
    },
    {
        key     = 'DownArrow',
        mods    = 'SUPER',
        action  = wezterm.action.ActivatePaneDirection 'Down'
    },
    {
        key     = 'Tab',
        mods    = 'SUPER|SHIFT',
        action  = wezterm.action.PaneSelect { mode = 'SwapWithActive' }
    },
    -- Basic Functionality --
    {
        key     = 'c',
        mods    = 'SUPER',
        action  = wezterm.action.CopyTo 'Clipboard'
    },
}

return config
