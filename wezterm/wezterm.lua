local wezterm = require 'wezterm'
local config = {}

config.enable_tab_bar = false
config.font = wezterm.font 'IosevkaTerm Nerd Font'
config.color_scheme = 'Black Metal (base16)'
config.window_background_opacity = 0.75

config.front_end = 'WebGpu' -- fixes textures not rendering properly on unstable branch of nixpkgs

return config
