[user]
	name =  {{name}} {{surname}}
	email = {{email}}
[core]
	editor = nvim
  pager = delta
  hooksPath = {{git_hooks_path}}
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
[init]
	defaultBranch = main
[alias]
  amend = commit --amend
  co = checkout
  discard = checkout --
  diffside = -c delta.side-by-side=true diff
  graph = log --graph -10 --branches --remotes --tags  --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %cr) %Cred%d' --date-order
  # main - to fetch, checkout main/master, and pull latest from remote
  main = ! MAIN=$(git branch -l master main | sed -r 's/^[* ] //' | head -n 1) && git fetch && git checkout $MAIN && git pull origin $MAIN
  # nevermind - unstages changes in the index, discards changes in the working directory, and removes any new files.
  nevermind = !git reset --hard HEAD && git clean -d -f
  remotes = remote -v
  root = rev-parse --show-toplevel
  unmerged = diff --name-only --diff-filter=U
  unstage = reset -q HEAD --
[filter "lfs"]
	required = true
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
