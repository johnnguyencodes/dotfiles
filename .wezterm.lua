-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.max_fps = 120
config.window_background_opacity = 0.7
config.color_scheme = "Catppuccin Mocha"

-- Add a startup_commands section to run "tmux attach" on launch
-- config.startup_commands = {
-- Run the tmux attach startup_command
-- }

-- Font configuration
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 25.0
-- and finally, return the configuration to wezterm
return config

