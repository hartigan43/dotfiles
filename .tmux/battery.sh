#! /bin/bash
# check if the device has a battery and show state / percentage if so

batteryCheck = $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage)
if [ -z "${battherChecky##*ignored*}" ]; then
$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | tr -s " " | cut -d ':' -f 2)$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | tr -s " " | cut -d ":" -f 2)
else
  echo " "
fi
