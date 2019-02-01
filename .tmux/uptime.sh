#! /bin/bash
uptime | awk -F'( |,|:)+' '{print $6"d "$8"h "$9"m"}'
