#!/bin/bash
# Cross-platform uptime script for Linux and macOS, using TMUX_OS_TYPE if available

# Prefer TMUX_OS_TYPE if set, otherwise fall back to uname
OS_TYPE="${TMUX_OS_TYPE:-$(uname | tr '[:upper:]' '[:lower:]')}"

if [[ "$OS_TYPE" == "darwin" ]]; then
  # macOS
  boot_time_raw=$(sysctl -n kern.boottime)
  boot_time=$(echo "$boot_time_raw" | awk -F'[ ,}]+' '{print $4}')
  now=$(date +%s)
  uptime_seconds=$((now - boot_time))
else
  # Linux
  uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
fi

days=$((uptime_seconds/60/60/24))
hours=$(( (uptime_seconds/60/60)%24 ))
minutes=$(( (uptime_seconds/60)%60 ))

printf "%01dd %01dh %02dm\n" "$days" "$hours" "$minutes"
