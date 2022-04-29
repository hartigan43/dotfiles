#!/bin/bash

# delay for any slow process exits
sleep 15 &

# hacky check for gamemode being run by lutris to see if any games are running
if ! [ "$(ps aux | grep lutris | grep gamemode)" ] ; then
  ulauncher
fi

exit
