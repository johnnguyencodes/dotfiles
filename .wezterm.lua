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
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120

-- Path to your wallpapers folder, relative to $HOME so this works on any
-- machine. Not committed to the dotfiles repo (binary assets) -- add your
-- own images here if you want the daily-wallpaper feature; it's skipped
-- gracefully if this folder doesn't exist.
local wallpapers_dir = wezterm.home_dir .. '/Catppuccin Wallpapers/landscapes/'

-- Define an array of wallpapers for each day
local daily_wallpapers = {
  "sunday.png",     -- 1 = Sunday
  "monday.png",     -- 2 = Monday
  "tuesday.png",    -- 3 = Tuesday
  "wednesday.png",  -- 4 = Wednesday
  "thursday.png",   -- 5 = Thursday
  "friday.png",     -- 6 = Friday
  "saturday.png",   -- 7 = Saturday
}

-- Function to get the current wallpaper for the day, or nil if the
-- wallpapers folder isn't present on this machine (skips the background
-- image entirely rather than erroring).
local function get_wallpaper()
  local day_of_week = tonumber(os.date("%w")) + 1 -- Lua starts at 0 for Sunday
  local path = wallpapers_dir .. daily_wallpapers[day_of_week]
  local file = io.open(path, "r")
  if file then
    file:close()
    return path
  end
  return nil
end

config.window_background_image = get_wallpaper()
config.window_background_image_hsb = {
  brightness = 0.075,
}

-- Update the wallpaper at midnight
wezterm.on("update-right-status", function(window, pane)
  local current_time = os.date("%H:%M")
  if current_time == "00:00" then
    config.window_background_image = get_wallpaper()
    window:set_config_overrides(config)
  end
end)

-- set default height
config.initial_rows = 66

config.window_padding = {
  left = '2cell',
  right = '1cell',
  top = '1.3cell',
  bottom = '0cell',
}

-- how many lines of scrollback you want to retain per tab
config.scrollback_lines = 3500

-- config.window_background_gradient = {
--   colors = { '#11111b', '#f38ba8' },
--   -- Specifices a Linear gradient starting in the top left corner.
--   orientation = { Linear = { angle = -45.0 } },
-- }

config.window_background_opacity = 1.0
config.color_scheme = "Catppuccin Mocha"

-- Add a startup_commands section to run "tmux attach" on launch
-- config.startup_commands = {
-- Run the tmux attach startup_command
-- }

-- Font configuration
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14.0
config.font_rules = {
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font {
      family = "JetBrains Mono",
      weight = "Bold",
      style = "Italic",
    },
  },
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font {
      family = "JetBrains Mono",
      weight = "DemiBold",
      style = "Italic",
    },
  },
  {
    italic = true,
    intensity = "Normal",
    font = wezterm.font {
      family = "JetBrains Mono",
      style = "Italic",
      weight = "Regular",
    },
  },
}

-- config to work with folke/zenmode
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config

