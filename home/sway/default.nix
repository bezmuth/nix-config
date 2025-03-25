# See https://codeberg.org/annaaurora/home-manager-config/ for an example config
{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: {
  imports = [../waybar ../mako];
  home = {
    packages = with pkgs; [
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
      alacritty
      wmenu
      light
      playerctl
      networkmanagerapplet
      blueman
      xfce.thunar
      light
      autotiling-rs
    ];
  };
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      menu = "wmenu-run";
      # Use kitty as default terminal
      terminal = "alacritty";
      startup = [
        {
          command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";
        }
        {command = "blueman-applet";}
        {command = "nm-applet --indicator";}
        {command = "kdeconnect-indicator";}
        {command = "autotiling-rs";}
        {command = "nextcloud";}
        {command = "thunderbird";}
        {command = "protonmail-bridge --grpc";}
        {command = "emacs";}
      ];
      assigns = {
        "10" = [{app_id = "thunderbird";}];
      };
      keybindings = let
        m = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${m}+t" = "split toggle";
          "${m}+bracketright" = "exec playerctl next";
          "${m}+bracketleft" = "exec playerctl play-pause";
          "${m}+p" = "exec playerctl previous";
          "grave" = "scratchpad show";
          "Shift+grave" = "move scratchpad";

          # function keys
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          # screenshots
          "Print" = "exec ''grim -g \"$(slurp)\" - | wl-copy -t image/png''";
          "Alt+Print" = "exec ''grim - | wl-copy -t image/png''";
        };
      input = {
        "type:keyboard" = {
          xkb_layout =
            if osConfig.networking.hostName == "Roshar"
            then "us"
            else "gb";
          xkb_options = "caps:escape";
        };
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "type:touchpad" = {
          tap = "enabled";
          dwt = "false";
        };
      };

      seat."*".hide_cursor = "3000";

      focus.wrapping = "force";

      output."DP-1".scale = "1.5";
      defaultWorkspace = "workspace number 1";

      bars = [];

      output."*" = {bg = "${./wallpaper.png} fill #000000";};
    };
  };
}
