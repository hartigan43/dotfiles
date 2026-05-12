-- Import the wezterm module
-- We almost always start by importing the wezterm module https://alexplescan.com/posts/2024/08/10/wezterm/
local wezterm = require 'wezterm'
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

local is_mac <const> = wezterm.target_triple:find("darwin") ~= nil

-- additional config from local files to include
local appearance = require 'appearance'
local keys = require 'keys'
local window = require 'window'

keys.apply_to_config(config)
window.apply_to_config(config)

if appearance.is_dark() then
  config.color_scheme = 'seoulbones_dark'
else
-- config.color_scheme = 'Seoul256 Light (Gogh)' -- only in nightly
  config.color_scheme = 'seoulbones_light'
end

-- font config
config.font = wezterm.font {
    family = 'Iosevka Nerd Font',
    weight = 'Regular',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', 'zero' },
}

config.font_size = 12
if is_mac then
  config.font_size = 13
end

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
