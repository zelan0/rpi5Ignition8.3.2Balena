#!/bin/bash

# Ställ CPU-scaling governor till 'performance' om möjligt
if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
  echo "Setting CPU governor to performance..."
  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
else
  echo "CPU governor not writable (may need privileged mode)"
fi

# Starta Ignition i förgrund
echo "Starting Ignition Gateway..."
exec /opt/ignition/ignition.sh console
