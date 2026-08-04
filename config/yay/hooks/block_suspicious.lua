-- Block install of PKGBUILDS that do _potentially_ shady things
-- https://www.fosslinux.com/158105/arch-linux-aur-supply-chain-security-audit-protect-pkgbuilds.htm
yay.create_autocmd('AURPreInstall', {
  callback = function(event)
    local blocked = {
      'curl.*|.*sh', 'wget.*|.*bash', 'eval%(',
      'rm %-rf /', 'chmod 777', 'base64 %-d',
    }
    for _, pattern in ipairs(blocked) do
      if event.data.pkgbuild:match(pattern) then
        yay.abort('[BLOCKED] Suspicious: ' .. pattern)
      end
    end
  end,
})
