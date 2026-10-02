{
  config,
  lib,
  ...
}:
{
  imports = [
    ../waybar
    ../mako # switch to swaynotificationcenter?
    ../swaylock
  ];
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    xwayland = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      menu = "wmenu-run";
      # Use alacritty as default terminal
      terminal = "alacritty";
      colors.focused = {
        background = "#f5c2e7";
        border = "#f5c2e7";
        childBorder = "#f5c2e7";
        indicator = "#f5c2e7";
        text = "#000000";
      };
      startup = [
        {
          command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";
        }
        { command = "nm-applet --indicator"; }
        { command = "kdeconnect-indicator"; }
        { command = "autotiling-rs"; }
        { command = "nextcloud"; }
        { command = "thunderbird"; }
        { command = "protonmail-bridge"; }
        { command = "solaar -w hide"; }
        # Idle
        { command = "idle.sh"; }
        { command = "signal-desktop"; }
      ];
      window.commands = [
        {
          command = "floating enable";
          criteria = {
            title = "winit window";
          };
        }
      ];
      assigns = {
        "10" = [ { app_id = "thunderbird"; } ];
      };
      keybindings =
        let
          m = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${m}+t" = "split toggle";
          "${m}+bracketright" = "exec playerctl next";
          "${m}+bracketleft" = "exec playerctl play-pause";
          "${m}+p" = "exec playerctl previous";
          "${m}+y" = "exec mpv --speed=2.0 $(wl-paste)";
          "${m}+Shift+v" = "exec video.sh";
          "${m}+Shift+r" = "exec radio.sh";
          "${m}+end" = "exec swaylock";

          # function keys
          "XF86MonBrightnessDown" = "exec brightnessctl s 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl s 5%+";
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
          xkb_layout = "gb";
          xkb_options = "caps:escape";
        };
        # lan-mouse config
        "0:0:wlr_virtual_keyboard_v1" = {
          xkb_layout = "gb";
          xkb_options = "caps:escape";
        };
        "6058:20564:ThinkPad_Extra_Buttons" = {
          xkb_layout = "gb";
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
        "12815:20571:Evision_RGB_Keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:escape";
        };
      };

      seat."*".hide_cursor = "5000";

      focus.wrapping = "force";

      output = {
        "*" = {
          bg = "${./wallpaper.jpg} fill #000000";
        };
        "HDMI-A-1" = {
          scale = "1.5";
          pos = "0 0";
        };
        "eDP-1" = {
          pos = "320 1440";
        };
        "DP-1".scale = "1.5";
      };
      defaultWorkspace = "workspace number 1";

      bars = [ ];
    };
  };
}
