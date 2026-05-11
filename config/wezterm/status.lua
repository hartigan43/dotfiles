local wezterm = require 'wezterm'
local M = {}

local symbols = require 'symbols'

wezterm.on('update-status', function(window)
  -- Grab the current window's configuration, and from it the
  -- palette (this is the combination of your chosen colour scheme
  -- including any overrides).
  local color_scheme = window:effective_config().resolved_palette
  -- TODO locals for to color_scheme.ansi[0/1..7/8] and color_scheme.brights?
  -- or reverse it and remove bg and fg?
  local bg = color_scheme.background
  local fg = color_scheme.foreground

  window:set_right_status(wezterm.format({
    -- start of bar
    { Background = { Color = 'none' } },
    { Foreground = { Color = color_scheme.ansi[7] } },
    { Text = symbols.PLE_LOWER_RIGHT_TRIANGLE },
    -- time date section
    { Background = { Color = color_scheme.ansi[7] } },
    { Foreground = { Color = color_scheme.ansi[1] } },
    { Text =  ' ' .. wezterm.strftime('%H:%M') .. ' ' .. symbols.PLE_FORWARDSLASH_SEPARATOR .. ' ' .. wezterm.strftime('%Y/%m/%d') .. ' ' },
    -- hostname section
    { Background = { Color = color_scheme.ansi[7] } },
    { Foreground = { Color = fg } },
    { Text = symbols.PLE_LOWER_RIGHT_TRIANGLE },
    -- Then we draw our text
    { Background = { Color = fg } },
    { Foreground = { Color = bg } },
    { Text = ' ' .. wezterm.hostname() .. ' ' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = symbols.PLE_UPPER_LEFT_TRIANGLE },
    -- silly accent
    { Background = { Color = bg } },
    { Foreground = { Color = bg } },
    { Text = ' ' },
  }))
end)

return M
