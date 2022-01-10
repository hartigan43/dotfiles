#! /bin/bash
# check if the device has a battery and show state / percentage if so

batteryCheck=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage)
if [ -z "${batteryCheck##*ignored*}" ]; then
  echo " "
else
  echo $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | tr -s " " | cut -d ':' -f 2)$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | tr -s " " | cut -d ":" -f 2)
fi
