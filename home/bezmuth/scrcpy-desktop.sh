#! /run/current-system/sw/bin/bash
adb shell settings put global overlay_display_devices "null"
adb shell settings put global overlay_display_devices 1920x1080/150

display_id=$(
  nix run nixpkgs#scrcpy -- --list-displays | grep display-id |   awk '/--display-id=/{sub(/.*=/,""); print $1}' | sed -n '2p'
)

echo "$display_id"

nix run nixpkgs#scrcpy -- --display-id $display_id --mouse=uhid --keyboard=uhid
adb shell settings put global overlay_display_devices "null"
