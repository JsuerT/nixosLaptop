-- /etc/nixos/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Gruvbox Dark'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 13.0

-- Fenster
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.90
config.scrollback_lines = 5000

-- Tab-Bar Styling
config.enable_tab_bar = true
config.use_fancy_tab_bar = false

return config

