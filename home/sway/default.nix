# See https://codeberg.org/annaaurora/home-manager-config/ for an example config
{
  pkgs,
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
  home = {
    file = {
      ".config/sway/idle.sh".source = ./idle.sh;
    };
    packages = with pkgs; [
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      alacritty
      wmenu
      playerctl
      networkmanagerapplet
      blueman
      xfce.thunar
      light
      autotiling-rs
      brightnessctl
    ];
  };
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
        { command = "~/.profile"; }
        { command = "blueman-applet"; }
        { command = "nm-applet --indicator"; }
        { command = "kdeconnect-indicator"; }
        { command = "autotiling-rs"; }
        { command = "nextcloud"; }
        { command = "thunderbird"; }
        { command = "protonmail-bridge --grpc"; }
        { command = "emacs"; }
        # Idle
        { command = "$HOME/.config/sway/idle.sh"; }
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
          "${m}+bracketright" = "exec playerctl -p spotify next";
          "${m}+bracketleft" = "exec playerctl -p spotify play-pause";
          "${m}+p" = "exec playerctl -p spotify previous";
          "grave" = "scratchpad show";
          "Shift+grave" = "move scratchpad";
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

      seat."*".hide_cursor = "3000";

      focus.wrapping = "force";

      output = {
        "*" = {
          bg = "${./wallpaper.png} fill #000000";
        };
        "HDMI-A-1" = {
          scale = "1.5";
          pos = "0 0";
        };
        "eDP-1" = {
          pos = "320 1440";
        };
        "DP-2".scale = "1.5";
      };
      defaultWorkspace = "workspace number 1";

      bars = [ ];
    };
  };
}
