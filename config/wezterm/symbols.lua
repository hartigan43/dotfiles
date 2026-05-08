local wezterm = require 'wezterm'
-- probably overconfigured, and simply referencing the wezterm.nerdfonts.*
-- I need in specific instances makes sense
-- TODO drop this in favor of a local wnf = wezterm.nerdfonts
-- https://wezterm.org/config/lua/wezterm/nerdfonts.html

local M = {
    -- ── Miscellaneous ──────────────────────────────────────────────────────────
    GIT_BRANCH                           = wezterm.nerdfonts.dev_git_branch,                        -- 

    -- ── Powerline (nf-pl-*) ───────────────────────────────────────────────────
    PL_BRANCH                            = wezterm.nerdfonts.pl_branch,                             -- 
    PL_CURRENT_LINE                      = wezterm.nerdfonts.pl_current_line,                       -- 
    PL_HOSTNAME                          = wezterm.nerdfonts.pl_hostname,                           -- 
    PL_LEFT_HARD_DIVIDER                 = wezterm.nerdfonts.pl_left_hard_divider,                  -- 
    PL_LEFT_SOFT_DIVIDER                 = wezterm.nerdfonts.pl_left_soft_divider,                  -- 
    PL_LINE_NUMBER                       = wezterm.nerdfonts.pl_line_number,                        -- 
    PL_READONLY                          = wezterm.nerdfonts.pl_readonly,                           -- 
    PL_RIGHT_HARD_DIVIDER                = wezterm.nerdfonts.pl_right_hard_divider,                 -- 
    PL_RIGHT_SOFT_DIVIDER                = wezterm.nerdfonts.pl_right_soft_divider,                 -- 

    -- ── Powerline Extra (nf-ple-*) ────────────────────────────────────────────
    PLE_BACKSLASH_SEPARATOR              = wezterm.nerdfonts.ple_backslash_separator,               -- 
    PLE_BACKSLASH_SEPARATOR_REDUNDANT    = wezterm.nerdfonts.ple_backslash_separator_redundant,     -- 
    PLE_COLUMN_NUMBER                    = wezterm.nerdfonts.ple_column_number,                     -- 
    PLE_CURRENT_COLUMN                   = wezterm.nerdfonts.ple_current_column,                    -- 
    PLE_FLAME_THICK                      = wezterm.nerdfonts.ple_flame_thick,                       -- 
    PLE_FLAME_THICK_MIRRORED             = wezterm.nerdfonts.ple_flame_thick_mirrored,              -- 
    PLE_FLAME_THIN                       = wezterm.nerdfonts.ple_flame_thin,                        -- 
    PLE_FLAME_THIN_MIRRORED              = wezterm.nerdfonts.ple_flame_thin_mirrored,               -- 
    PLE_FORWARDSLASH_SEPARATOR           = wezterm.nerdfonts.ple_forwardslash_separator,            -- 
    PLE_FORWARDSLASH_SEPARATOR_REDUNDANT = wezterm.nerdfonts.ple_forwardslash_separator_redundant,  -- 
    PLE_HONEYCOMB                        = wezterm.nerdfonts.ple_honeycomb,                         -- 
    PLE_HONEYCOMB_OUTLINE                = wezterm.nerdfonts.ple_honeycomb_outline,                 -- 
    PLE_ICE_WAVEFORM                     = wezterm.nerdfonts.ple_ice_waveform,                      -- 
    PLE_ICE_WAVEFORM_MIRRORED            = wezterm.nerdfonts.ple_ice_waveform_mirrored,             -- 
    PLE_LEFT_HALF_CIRCLE_THICK           = wezterm.nerdfonts.ple_left_half_circle_thick,            -- 
    PLE_LEFT_HALF_CIRCLE_THIN            = wezterm.nerdfonts.ple_left_half_circle_thin,             -- 
    PLE_LEFT_HARD_DIVIDER_INVERSE        = wezterm.nerdfonts.ple_left_hard_divider_inverse,         -- 
    PLE_LEGO_BLOCK_FACING                = wezterm.nerdfonts.ple_lego_block_facing,                 -- 
    PLE_LEGO_BLOCK_SIDEWAYS              = wezterm.nerdfonts.ple_lego_block_sideways,               -- 
    PLE_LEGO_SEPARATOR                   = wezterm.nerdfonts.ple_lego_separator,                    -- 
    PLE_LEGO_SEPARATOR_THIN              = wezterm.nerdfonts.ple_lego_separator_thin,               -- 
    PLE_LOWER_LEFT_TRIANGLE              = wezterm.nerdfonts.ple_lower_left_triangle,               -- 
    PLE_LOWER_RIGHT_TRIANGLE             = wezterm.nerdfonts.ple_lower_right_triangle,              -- 
    PLE_PIXELATED_SQUARES_BIG            = wezterm.nerdfonts.ple_pixelated_squares_big,             -- 
    PLE_PIXELATED_SQUARES_BIG_MIRRORED   = wezterm.nerdfonts.ple_pixelated_squares_big_mirrored,    -- 
    PLE_PIXELATED_SQUARES_SMALL          = wezterm.nerdfonts.ple_pixelated_squares_small,           -- 
    PLE_PIXELATED_SQUARES_SMALL_MIRRORED = wezterm.nerdfonts.ple_pixelated_squares_small_mirrored,  -- 
    PLE_RIGHT_HALF_CIRCLE_THICK          = wezterm.nerdfonts.ple_right_half_circle_thick,           -- 
    PLE_RIGHT_HALF_CIRCLE_THIN           = wezterm.nerdfonts.ple_right_half_circle_thin,            -- 
    PLE_RIGHT_HARD_DIVIDER_INVERSE       = wezterm.nerdfonts.ple_right_hard_divider_inverse,        -- 
    PLE_TRAPEZOID_TOP_BOTTOM             = wezterm.nerdfonts.ple_trapezoid_top_bottom,              -- 
    PLE_TRAPEZOID_TOP_BOTTOM_MIRRORED    = wezterm.nerdfonts.ple_trapezoid_top_bottom_mirrored,     -- 
    PLE_UPPER_LEFT_TRIANGLE              = wezterm.nerdfonts.ple_upper_left_triangle,               -- 
    PLE_UPPER_RIGHT_TRIANGLE             = wezterm.nerdfonts.ple_upper_right_triangle,              -- 
}

return M
