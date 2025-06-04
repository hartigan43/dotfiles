[font]
size = {{font_size}}

  [font.normal]
  family = "{{monospace}}"
  style = "Regular"

  [font.bold]
  style = "Bold"

  [font.italic]
  style = "Italic"

  [font.bold_italic]
  style = "Bold Italic"

[[hints.enabled]]
command         = {{hints_command}}
regex           = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`\\\\]+"
hyperlinks      = true
post_processing = true
mouse           = { enabled = true, mods = "None" }
binding         = { key = "O", mods = "Control|Shift" }

[scrolling]
history = 1_000

[terminal]

[terminal.shell]
program = "/bin/zsh"

[window]
dimensions.columns = {{#if t_cols}}{{t_cols}}{{else}}0{{/if}}
dimensions.lines   = {{#if t_lines}}{{t_lines}}{{else}}0{{/if}}

{{#if (eq platform "Darwin")}}
option_as_alt = "OnlyRight"
{{/if}}
