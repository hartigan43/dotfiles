#!/bin/env zsh

#https://github.com/zpm-zsh/zpm
#zpm
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --depth 1 https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

### Core
zpm if ssh     \
  zpm-zsh/tmux \

zpm if-not ssh            \
  zpm-zsh/tmux,apply:path \

### Compatibility
zpm if termux          \
  zpm-zsh/termux,async \

### 3party plugins
zpm                                                \
  zpm-zsh/core-config                              \
  zpm-zsh/ignored-users,async                      \
#  zpm-zsh/minimal-theme                            \
  zpm-zsh/check-deps                               \
  zpm-zsh/ssh,async                                \

zpm if-not ssh                                                                         \
  zpm-zsh/clipboard,async                                                              \
  zpm-zsh/mysql-colorize,async                                                         \
  zsh-users/zsh-completions,apply:fpath,fpath:/src                                     \
  zsh-users/zsh-history-substring-search,source:zsh-history-substring-search.zsh,async \
  zdharma/fast-syntax-highlighting,async                                               \
  horosgrisa/zsh-autosuggestions,source:zsh-autosuggestions.zsh,async                  \

zpm                           \
  omz/command-not-found,async \
  omz/colored-man-pages       \
  omz/docker                  \
  omz/docker-compose          \
  omz/git                     \
  omz/pyenv                   \
  omz/pip                     \
  omz/rbenv                   \
  omz/safe-paste              \
  omz/systemd                 \
  omz/z                       \
