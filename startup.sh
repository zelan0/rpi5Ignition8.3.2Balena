#!/bin/bash

# Ställ CPU-scaling governor till 'performance' om möjligt
if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi

# Skapa och aktivera swap (2 GB) om det inte redan finns
SWAPFILE="/mnt/data/swapfile"
if [ ! -f "$SWAPFILE" ]; then
  fallocate -l 2G "$SWAPFILE" || dd if=/dev/zero of="$SWAPFILE" bs=1M count=2048
  chmod 600 "$SWAPFILE"
  mkswap "$SWAPFILE"
fi
swapon "$SWAPFILE"

# Starta Ignition i förgrund
exec /opt/ignition/ignition.sh console
