local wezterm = require 'wezterm'
-- module to contain any custom color schemes
-- TODO use files config.color_scheme_dirs = { '/some/path/to/my/color/schemes' }
-- https://wezterm.org/config/appearance.html#defining-a-color-scheme-in-a-separate-file

local M = {}

function M.apply_to_config(config)
  config.color_schemes = {
    ['seoul256_mod'] = {

    },
  }

end


return M
