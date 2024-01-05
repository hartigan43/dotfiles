#!/bin/sh

/usr/bin/sh -c 'if [ -d \"$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat\" ]; then rm -rf \"$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat\"; fi'
/usr/bin/sh -c "sed -i 's|\"productid\":.*|\"productid\": \"linux-eac-workaround\",|' \"$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE/EasyAntiCheat/Settings.json\""

source ./pre.sh
