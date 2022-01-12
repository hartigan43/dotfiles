#!/bin/bash
# screenshot the current active window using imagemagick and xdotool
# written up for lutris screens

if [ ! -d "$HOME/Pictures/Screenshots/$(xdotool getwindowname $(xdotool getwindowfocus -f))" ]; then
  mkdir -p "$HOME/Pictures/Screenshots/$(xdotool getwindowname $(xdotool getwindowfocus -f))"
fi

import -window "$(xdotool getwindowfocus -f)" "$HOME/Pictures/Screenshots/$(xdotool getwindowname $(xdotool getwindowfocus -f))/$(date +%Y%m%d-%H%M%S).png"
