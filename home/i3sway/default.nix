{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ../alacritty ../rofi ../waybar ../mako ];

  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions
    swaylock
    blueman
    networkmanagerapplet
  ];

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
        "${m}+space" = "exec ${menu} -show drun -show-icon";
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
    configure-gtk = pkgs.writeTextFile {
      # see:  https://discourse.nixos.org/t/some-loose-ends-for-sway-on-nixos-which-we-should-fix/17728/2
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'catppuccin-mocha-pink-compact'
        gsettings set $gnome_schema icon-theme 'Papirus-Dark'
      '';
    };
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
    importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
      ${gsettings} set ${gnomeSchema} gtk-theme "Catppuccin"
      ${gsettings} set ${gnomeSchema} icon-theme "Papirus-Dark"
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
        { command = "${configure-gtk}"; }
        { command = "waybar"; }
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
        "${m}+space" = "exec '${menu} -show drun -show-icon'";
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

      focus.wrapping = "force";

      #output."*".bg = "background.png fill";

    };
  };
}
