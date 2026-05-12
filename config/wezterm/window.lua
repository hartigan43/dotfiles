local wezterm = require 'wezterm'
local M = {}

local status = require 'status' -- upper right status bar configured in status.lua
local symbols = require 'symbols'

local is_mac <const> = wezterm.target_triple:find("darwin") ~= nil

function M.apply_to_config(config)
  -- tab settings
  -- config.show_close_tab_button_in_tabs = false -- nightly only
  if is_mac then
    config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
  end
  -- window settings
  config.window_background_opacity = 1.0
  -- Sets the font for the window frame (tab bar)
  config.window_frame = {
      font = wezterm.font({ family = 'Iosevka Nerd Font', weight = 'Bold' }),
      font_size = 12,
  }
  config.window_padding = {
    left = '0.25cell',  -- 1
    right = '0.25cell', -- 1
    top = '0.1cell',    -- 0.5
    bottom = '0.1cell', -- 0.5
  }
end

return M
