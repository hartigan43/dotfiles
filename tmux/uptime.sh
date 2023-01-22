#! /bin/bash
# from https://unix.stackexchange.com/questions/83404/how-do-i-show-simple-uptime-in-tmuxs-status-bar
awk '{printf("%01dd %01dh %02dm",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime
