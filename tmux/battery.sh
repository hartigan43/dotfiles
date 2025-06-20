#!/bin/bash
# Cross-platform battery status script with optional Nerd Font icons

USE_ICON_FONT=true  # Set to false if you don't have Nerd Fonts

declare -A state_map_icon
state_map_icon[discharging]="󱟤"
state_map_icon[charging]="󰂄"
state_map_icon[charged]="󱟢"

declare -A state_map_label
state_map_label[discharging]="DIS"
state_map_label[charging]="CHR"
state_map_label[charged]="FULL"

get_state_display() {
  local state="$1"
  if [ "$USE_ICON_FONT" = true ]; then
    echo "${state_map_icon[$state]:-${state_map_label[$state]}}"
  else
    echo "${state_map_label[$state]}"
  fi
}

# Prefer TMUX_OS_TYPE if set, otherwise fall back to uname
OS_TYPE="${TMUX_OS_TYPE:-$(uname | tr '[:upper:]' '[:lower:]')}"

if [[ "$OS_TYPE" == "darwin" ]]; then
  # macOS
  battery_info=$(pmset -g batt)
  percentage=$(echo "$battery_info" | grep -o '[0-9]\{1,3\}%')
  state=$(echo "$battery_info" | grep -o 'discharging\|charging\|charged')
  if [ -n "$percentage" ] && [ -n "$state" ]; then
    display=$(get_state_display "$state")
    echo " $percentage $display "
  else
    echo " "
  fi
else
  # Assume Linux with upower
  batteryCheck=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage)
  if [ -z "${batteryCheck##*ignored*}" ]; then
    echo " "
  else
    state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | tr -s " " | cut -d ':' -f 2 | xargs)
    percent=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | tr -s " " | cut -d ":" -f 2 | xargs)
    display=$(get_state_display "$state")
    echo " $percent $display "
  fi
fi
