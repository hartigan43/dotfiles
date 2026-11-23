-- yay init.lua
--
-- reference https://github.com/Jguer/yay/blob/next/doc/init.lua for all available options
-- Command-line flags still override these values

-- yay.opt.clean_after = true
-- yay.opt.debug = true
-- yay.opt.devel = false
-- yay.opt.diff_menu = true -- show diffs to review
-- yay.opt.edit_menu = true -- show PKGBUILD edit menu
yay.opt.completion_refresh_time = 10
yay.opt.max_concurrent_downloads = 3

-- Hooks
require("hooks.block_suspicious")
require("hooks.skip_recently_modified")
require("hooks.maintainer_change")
