#!/bin/bash

# Get the number of connected monitors
MONITORS=$(xrandr --query | grep " connected" | wc -l)

# Get monitor names
MONITOR_1=$(xrandr --query | grep " connected" | awk 'NR==1{print $1}')
MONITOR_2=$(xrandr --query | grep " connected" | awk 'NR==2{print $1}')

# Only run if exactly 2 monitors are connected
if [ "$MONITORS" -eq 2 ]; then
    # Assign odd workspaces to MONITOR_2
    for ws in 1 3 5 7 9; do
        i3-msg "workspace $ws; move workspace to output $MONITOR_2"
    done

    # Assign even workspaces to MONITOR_1
    for ws in 2 4 6 8 10; do
        i3-msg "workspace $ws; move workspace to output $MONITOR_1"
    done
fi

