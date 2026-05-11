local wezterm = require 'wezterm'
local act = wezterm.action
local keys_config = {}
local M = {}

local function add_keys(bindings)
  for _, binding in ipairs(bindings) do
    table.insert(keys_config.keys, binding)
  end
end

local function move_pane(keys, direction, mods)
  mods = mods or 'LEADER' -- default to LEADER key unless otherwise specified

  local bindings = {} -- store the bindings for return to config.keys later

  for _,key in ipairs(keys) do
    table.insert(bindings, {
      key = key,
      mods = mods,
      action = act.ActivatePaneDirection(direction),
    })
  end

  return bindings
end

local function select_tabs()
  local bindings = {} -- store the bindings for return to config.keys later

  for i = 1, 8 do
    table.insert(bindings, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
    })
  end

  return bindings
end

-- mimic my tmux configuration with "CTRL+F" leader
keys_config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }
keys_config.keys = {
  -- allow leader passthrough as "CTRL+F"
  {
    key = 'f',
    -- When we're in leader mode _and_ "CTRL+F" is pressed...
    mods = 'LEADER|CTRL',
    -- Actually send CTRL + F key to the terminal
    action = act.SendKey { key = 'f', mods = 'CTRL' },
  },
  -- open wezterm config file in macOS "CMD+," fashion
  -- likely needs path fix on macOS, see
  -- https://alexplescan.com/posts/2024/08/10/wezterm/#keys
  {
    key = ',',
    mods = 'SUPER',
    action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'nvim', wezterm.config_file },
    },
  },
  -- panes
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  -- splits
  {
    key = '|', -- " is tmux default
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-', -- % is tmux default
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- tabs
  {
    key = 'o', -- using 2xCTRL+F currently with tmux
    mods = 'LEADER',
    action = wezterm.action.ActivateLastTab,
  },
}

-- split movement - vim binds
add_keys(move_pane({'j', 'DownArrow'}, 'Down'))
add_keys(move_pane({'k', 'UpArrow'}, 'Up'))
add_keys(move_pane({'h', 'LeftArrow'}, 'Left'))
add_keys(move_pane({'l', 'RightArrow'}, 'Right'))
-- tab management
add_keys(select_tabs())

function M.apply_to_config(config)
  config.leader = keys_config.leader
  config.keys = keys_config.keys
end

return M
