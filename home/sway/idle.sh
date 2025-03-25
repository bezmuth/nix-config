#!/bin/sh
exec swayidle -w \
    timeout 480 swaylock \
    timeout 960 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
    #timeout 600 'systemctl suspend"' \
    before-sleep '~/config/sway/lock.sh' \
