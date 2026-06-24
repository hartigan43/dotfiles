-- yay init.lua
--
-- reference https://github.com/Jguer/yay/blob/next/doc/init.lua for all available options
-- Command-line flags still override these values

-- yay.opt.debug = true
yay.opt.completion_refresh_time = 10
yay.opt.max_concurrent_downloads = 3

-- Hooks
require("hooks.skip_recently_modified")
require("hooks.maintainer_change")
--yay.create_autocmd("UpgradeSelect", {
--  desc = "skip recently modified AUR upgrades -- 5 day threshold",
--  callback = function(event)
--    yay.log.info("pre-excluding AUR packages modified in the last 5 days")
--    local exclude = {}
--    local recent_cutoff = os.time() - (5 * 24 * 60 * 60)
--    for _, pkg in ipairs(event.data.upgrades) do
--      if pkg.repository == "aur" and pkg.last_modified >= recent_cutoff then
--        yay.log.warn("pre-excluding recently modified AUR package: ", pkg.name)
--        table.insert(exclude, pkg.name)
--      end
--    end
--
--    return { exclude = exclude, skip_menu = false }
--  end,
--})
