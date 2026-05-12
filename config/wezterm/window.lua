local wezterm = require 'wezterm'
local M = {}

local status = require 'status' -- upper right status bar configured in status.lua
local symbols = require 'symbols'

local is_mac <const> = wezterm.target_triple:find("darwin") ~= nil

-- This function returns the suggested title for a tab. It prefers the title that
-- was set via `tab:set_title()` or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
-- TODO this file needs some love and maybe  merging with status?
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, use it
  if title and #title > 0 then
    return ' ' .. tab_info.tab_id+1 .. ' | ' .. title .. ' '
  end
  -- Otherwise, use the title from the active pane in that tab
  return ' ' .. tab_info.tab_id+1 .. ' | ' .. tab_info.active_pane.title .. ' '
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#333333'
    local background = '#333333'
    local foreground = '#808080'

    if tab.is_active then
      background = '#008586'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#222222'
      foreground = '#e2e2e2'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = symbols.PLE_LOWER_RIGHT_TRIANGLE },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = symbols.PLE_UPPER_LEFT_TRIANGLE },
    }
  end
)

function M.apply_to_config(config)
  -- tab_bar and tab settings
  if is_mac then  -- fancy_tab_bar settings belong here for macOS only as it looks best integrated
    -- config.show_close_tab_button_in_tabs = false -- nightly only
    config.tab_bar_at_bottom = false
    config.use_fancy_tab_bar = true
    config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

    config.window_frame = {
        font = wezterm.font({ family = 'Iosevka Nerd Font', weight = 'Medium' }),
        font_size = 12,
    }
  else
    -- TODO use a better method for setting colors based on theme
    local tab_bg = '#333333'
    config.tab_bar_at_bottom = true
    config.tab_max_width = 24
    config.use_fancy_tab_bar = false

    config.colors = {
      tab_bar = {
        background = tab_bg,
        active_tab = {
          bg_color = '#008586',
          fg_color = '#e2e2e2',
          intensity = 'Bold',
          underline = 'None',
        },
        inactive_tab = {
          bg_color = tab_bg,
          fg_color = '#c0c0c0',
        }
      },
    }
  end

  -- window settings
  config.window_background_opacity = 1.0

  -- Sets the font for the window frame (tab bar)
  config.window_padding = {
    left = '0.25cell',  -- 1
    right = '0.25cell', -- 1
    top = '0.1cell',    -- 0.5
    bottom = '0.1cell', -- 0.5
  }
end

return M
