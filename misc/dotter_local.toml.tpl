includes = []
packages = ["alacritty", "graphics", "linux", "shell", "vim", "zsh"]

[alacritty.variables]
font_size = 12
monospace = "Iosevka Term"
t_cols    = 317
t_lines   = 62

[files]

[variables]
email         = "hartiganj@protonmail.com"
name          = "Jake"
surname       = "Hartigan"
{{#if dotter.linux }}
hints_command = "xdg-open"
platform      = "Linux"
regular       = "Noto Sans"
{{#/if}}
{{#if dotter.macos }}
hints_command = "open"
platform      = "Darwin"
{{#/if}}
