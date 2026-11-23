-- Block install of PKGBUILDS that do _potentially_ shady things
-- modified from: https://www.fosslinux.com/158105/arch-linux-aur-supply-chain-security-audit-protect-pkgbuilds.htm
yay.create_autocmd('AURPreInstall', {
  callback = function(event)
    local pkgbuild = event.data.pkgbuild

    local function is_comment_line(line)
      return line:match("^%s*#") ~= nil
    end

    -- Allowed only when on commented lines, such as for obfuscating maintainer email
    local allowed_in_comments = {
      'base64%s*%-d'
    }

    local blocked = {
      -- decode and exec pipes
      'base64%s*%-d.-|%s*sh',
      'base64%s*%-d.-|%s*bash',

      -- curl pipes -- “curl ... | sh” / “curl ... | bash”
      'curl.-|%s*sh',
      'curl.-|%s*bash',

      -- wget pipes -- “wget ... | sh” / “wget ... | bash”
      'wget.-|%s*sh',
      'wget.-|%s*bash',

      -- other likely bad actors
      'eval%(',
      'rm %-rf /',
      'chmod 777',
    }

    -- check against the allowed_in_comments list and if the pattern is on a non-commented line, abort
    for line in pkgbuild:gmatch("([^\n]*)\n?") do
      if not is_comment_line(line) then
        for _, pattern in ipairs(allowed_in_comments) do
          if line:match(pattern) then
            yay.abort('[BLOCKED] Suspicious: ' .. pattern .. ' outside comment code')
          end
        end
      end
    end

    -- check against blocked patterns across the entire PKGBUILD
    for _, pattern in ipairs(blocked) do
      if pkgbuild:match(pattern) then
        yay.abort('[BLOCKED] Suspicious: ' .. pattern)
      end
    end
  end,
})
