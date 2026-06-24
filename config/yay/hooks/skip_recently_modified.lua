-- skips recently modified packages (5 days)
-- https://github.com/Jguer/yay/blob/next/doc/examples/recently_modified.lua

yay.create_autocmd("UpgradeSelect", {
  desc = "skip recently modified AUR upgrades -- 5 day threshold",
  callback = function(event)
    yay.log.info("pre-excluding AUR packages modified in the last 5 days")
    local exclude = {}
    local recent_cutoff = os.time() - (5 * 24 * 60 * 60)
    for _, pkg in ipairs(event.data.upgrades) do
      if pkg.repository == "aur" and pkg.last_modified >= recent_cutoff then
        yay.log.warn("pre-excluding recently modified AUR package: ", pkg.name)
        table.insert(exclude, pkg.name)
      end
    end

    return { exclude = exclude, skip_menu = false }
  end,
})

