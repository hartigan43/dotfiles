[user]
	name = {{ name }} {{ surname }}
	email = {{ email }}
[core]
	editor = {{ editor }}
  pager = {{ pager }}
  hooksPath = {{ hooksPath }}
{{#if (eq pager "delta")}}
[delta]
  navigate = true    # use n and N to move between diff sections

  # delta detects terminal colors automatically; set one of these to disable auto-detection
  # dark = true
  light = true
  # side-by-side = true
  syntax-theme = gruvbox-light
[diff]
  colorMoved = default
[interactive]
  diffFilter = delta --color-only
{{/if}}
[init]
	defaultBranch = main
[alias]
  main = ! MAIN=$(git branch -l master main | sed -r 's/^[* ] //' | head -n 1) && git fetch && git checkout $MAIN && git pull origin $MAIN
[filter "lfs"]
	required = true
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
