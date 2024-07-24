-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.window_background_opacity = 0.7

config.window_padding = {
  left = '10px',
  right = '10px',
  top = '20px',
  bottom = '20px',
}

config.font = wezterm.font 'MesloLGS NF'
config.font_size = 14.0

config.tab_bar_at_bottom = true

-- For example, changing the color scheme:
config.color_scheme = 'ChallengerDeep'

-- and finally, return the configuration to wezterm
return config

