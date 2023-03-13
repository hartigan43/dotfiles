#!/bin/bash

# delay for any slow process exits
sleep 25 &

#less hacky check to see if any lutris runners are active
if ! [ "$(ps aux | grep '[l]utris/runners')" ] ; then
  (ulauncher > /dev/null 2>&1) & disown
fi

exit 1
