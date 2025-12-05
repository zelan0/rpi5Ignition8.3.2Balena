#!/bin/bash

# Ställ CPU-scaling governor till 'performance' om möjligt
if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi

# Skapa och aktivera swap (2 GB) om det inte redan finns
# Använder ignition-data volymen som är monterad på /opt/ignition/data
SWAPFILE="/opt/ignition/data/swapfile"
if [ ! -f "$SWAPFILE" ]; then
  echo "Creating swap file..."
  fallocate -l 2G "$SWAPFILE" 2>/dev/null || dd if=/dev/zero of="$SWAPFILE" bs=1M count=2048 2>/dev/null || {
    echo "Warning: Could not create swap file (may not be needed)"
  }
  if [ -f "$SWAPFILE" ]; then
    chmod 600 "$SWAPFILE"
    mkswap "$SWAPFILE"
    swapon "$SWAPFILE" || echo "Warning: Could not activate swap"
  fi
fi

# Starta Ignition i förgrund
exec /opt/ignition/ignition.sh console
