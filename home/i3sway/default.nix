{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ../waybar ];

  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      colors.focused = {
        background = "#89dceb";
        border = "#89dceb";
        childBorder = "#89dceb";
        indicator = "#89dceb";
        text = "#000000";
      };
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi";
      bars = [{
        position = "top";
        trayOutput = "DP-0";
        statusCommand = "i3status";
      }];
      gaps = {
        smartGaps = true;
        smartBorders = "on";
        outer = 0;
        inner = 0;
      };
      window = {
        border = 1;
        commands = [
          {
            criteria = { title = "^(.*) Proton VPN ^(.*)"; };
            command = "floating enable";
          }
          {
            criteria = { title = "Bluetooth Devices"; };
            command = "floating enable";
          }
          {
            criteria = { title = "Image Occlusion Enhanced - Add Mode"; };
            command = "floating enable";
          }
        ];
      };
      keybindings = let m = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        "${m}+Return" = "exec ${terminal}";
        "${m}+space" = "exec ${menu} -show drun -show-icons";
        "${m}+t" = "split toggle";
        "${m}+bracketright" = "exec playerctl next";
        "${m}+bracketleft" = "exec playerctl play-pause";
        "${m}+p" = "exec playerctl previous";
        "grave" = "scratchpad show";
        "Shift+grave" = "move scratchpad";

        "${m}+h" = "focus left";
        "${m}+j" = "focus down";
        "${m}+k" = "focus up";
        "${m}+l" = "focus right";

        # function keys
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86AudioRaiseVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # screenshots
        "Print" = "exec flameshot gui";
        "Alt+Print" = "exec ''grim - | wl-copy -t image/png''";
      };
      startup = [
        { command = "picom"; }
        { command = "blueman-applet"; }
        { command = "nm-applet --indicator"; }
        { command = "kdeconnect-indicator"; }
        { command = "keepassxc"; }
        { command = "keepassxc"; }
        { command = "./home/bezmuth/Projects/rust/snore/target/release/snore"; }
      ];
    };
  };

  wayland.windowManager.sway = let
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
    importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
      config="/home/alternateved/.config/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
      ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
      ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
      ${gsettings} set ${gnomeSchema} font-name "$font_name"
    '';
  in {
    enable = true;
    xwayland = true;
    systemdIntegration = true;
    config = rec {
      colors.focused = {
        background = "#89dceb";
        border = "#89dceb";
        childBorder = "#89dceb";
        indicator = "#89dceb";
        text = "#000000";
      };
      bars = [ ];
      startup = [
        {
          command =
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";
        }
        { command = "${importGsettings}"; }
        { command = "blueman-applet"; }
        { command = "nm-applet --indicator"; }
        { command = "kdeconnect-indicator"; }
        { command = "keepassxc"; }
      ];
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi";
      keybindings = let m = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${m}+Return" = "exec ${terminal}";
        "${m}+space" = "exec '${menu} -show drun -show-icons'";
        "${m}+t" = "split toggle";
        "${m}+bracketright" = "exec playerctl next";
        "${m}+bracketleft" = "exec playerctl play-pause";
        "${m}+p" = "exec playerctl previous";
        "grave" = "scratchpad show";
        "Shift+grave" = "move scratchpad";

        # function keys
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86AudioRaiseVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # screenshots
        "Print" = "exec ''grim -g \"$(slurp)\" - | wl-copy -t image/png''";
        "Alt+Print" = "exec ''grim - | wl-copy -t image/png''";
      };

      gaps = {
        smartGaps = true;
        smartBorders = "on";
        outer = 0;
        inner = 0;
      };

      window = {
        border = 1;
        commands = [
          {
            criteria = { title = "^(.*) Proton VPN ^(.*)"; };
            command = "floating enable";
          }
          {
            criteria = { title = "Bluetooth Devices"; };
            command = "floating enable";
          }
          {
            criteria = { title = "Image Occlusion Enhanced - Add Mode"; };
            command = "floating enable";
          }
        ];
      };

      input = {
        "type:keyboard" = {
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
      };

      seat."*".hide_cursor = "3000";

      focus.forceWrapping = true;

      output."*".bg = "~/Pictures/background.png fill";

    };
  };
}
