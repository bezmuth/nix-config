{ config, pkgs, lib, inputs, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsUnstable;
  };

  programs.zsh = {
    enable = true; # Your zsh config
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
      theme = "af-magic";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        let $config = {
          filesize_metric: false,
          table_mode: rounded,
          use_ls_colors: true,
          show_banner: false,
        }
      '';
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$line_break"
        "$package"
        "$line_break"
        "$character"
      ];
      scan_timeout = 10;
      character = {
        success_symbol = "➜(bold green)";
        error_symbol = "➜(bold red)";
      };
    };
  };

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    firefox
    syncthing
    keepassxc
    discord
    protonvpn-gui
    pandoc # emacs
    nixfmt # emacs
    lorri
    element-desktop
    prismlauncher
    nodejs
    bat
    vlc
    libreoffice-fresh
    scrcpy
    rsync
    nixfmt
    anki-bin
    plantuml
    graphviz
    texlive.combined.scheme-full
    tor-browser-bundle-bin
    tootle
    piper
    gnome-feeds
    calibre
    grim
    mitmproxy
    font-awesome
    playerctl
    ranger
    tmux
    pavucontrol
    pulseaudio
    networkmanagerapplet
    nerdfonts
    catppuccin-gtk
    catppuccin-cursors
    i2p
    transmission-gtk
    gnome.nautilus
    haruna
    gqrx
    kiwix
    picom
    htop
    snore
  ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors;
    name = "mochaLite";
    gtk.enable = true;
  };

  gtk = {
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "EPapirus";
    theme.package = pkgs.catppuccin-gtk;
    theme.name = "Catppuccin-Dark";
  };

  programs.bash.bashrcExtra = "tmux";

  programs.zathura = {
    enable = true;
    extraConfig = ''
      set default-fg                 "#CDD6F4"
      set default-bg                 "#1E1E2E"
      set completion-bg              "#313244"
      set completion-fg              "#CDD6F4"
      set completion-highlight-bg    "#575268"
      set completion-highlight-fg    "#CDD6F4"
      set completion-group-bg        "#313244"
      set completion-group-fg        "#89B4FA"
      set statusbar-fg               "#CDD6F4"
      set statusbar-bg               "#313244"
      set notification-bg            "#313244"
      set notification-fg            "#CDD6F4"
      set notification-error-bg      "#313244"
      set notification-error-fg      "#F38BA8"
      set notification-warning-bg    "#313244"
      set notification-warning-fg    "#FAE3B0"
      set inputbar-fg                "#CDD6F4"
      set inputbar-bg                "#313244"
      set recolor-lightcolor         "#1E1E2E"
      set recolor-darkcolor          "#CDD6F4"
      set index-fg                   "#CDD6F4"
      set index-bg                   "#1E1E2E"
      set index-active-fg            "#CDD6F4"
      set index-active-bg            "#313244"
      set render-loading-bg          "#1E1E2E"
      set render-loading-fg          "#CDD6F4"
      set highlight-color            "#575268"
      set highlight-fg               "#F5C2E7"
      set highlight-active-color     "#F5C2E7"

      set recolor "true"
      set recolor-reverse-video "true"
      set recolor-keephue "true"
    '';
  };

  programs.spicetify = {
    enable = true;
    theme =
      inputs.spicetify-nix.packages.${pkgs.system}.default.themes.catppuccin-mocha;
    colorScheme = "flamingo";

    enabledExtensions =
      with inputs.spicetify-nix.packages.${pkgs.system}.default.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        keyboardShortcut
        popupLyrics
        playlistIcons
        genre
        playNext
        volumePercentage
      ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override {
      plugins = [ pkgs.rofi-emoji pkgs.rofi-power-menu ];
    };
    extraConfig = {
      modi =
        "run,drun,emoji,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
      show-icons = true;
      icon-theme = "Papirus";
      terminal = "alacritty";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "  Apps ";
      display-run = "  Run ";
      display-emoji = "  Emoji";
      display-Power-menu = "  Power";
      sidebar-mode = true;
    };
    theme = ./rofi-catppuccin.rasi;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # Colors (catppuccin-mocha)
      colors = {
        # Default colors
        cursor = {
          text = "0x1E1E2E";
          cursor = "0xF5E0DC";
        };

        primary = {
          # hard contrast: background = '#1d2021'
          background = "#1E1E2E";
          # soft contrast: background = "#32302f"
          foreground = "#CDD6F4";
        };
        # Normal colors
        normal = {
          black = "#45475A"; # surface1
          red = "#F38BA8"; # red
          green = "#A6E3A1"; # green
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#BAC2DE"; # subtext1
        };

        # Bright colors
        bright = {
          black = "#585B70"; # surface2
          red = "#F38BA8"; # red
          green = "#A6E3A1"; # green
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#A6ADC8"; # subtext0
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # mocha
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      window#waybar {
        background-color: @base;
        border-bottom: @surface1;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }
      #workspaces button.focused {
        background-color: @surface0;
        box-shadow: inset 0 -3px @surface1;
      }
      #clock {
        background-color: @surface0;
        color: @text;
      }
      #battery {
          background-color: @green;
          color: @base;
      }
      #temperature {
          background-color: @maroon;
          color: @base;
      }
      #memory {
          background-color: @sky;
          color: @base;
      }
      #network {
          background-color: @blue;
          color: @base;
      }
      #tray {
          background-color: @surface0;
          color: @base;
      }
      #cpu {
          background-color: @pink;
          color: @base;
      }
      #pulseaudio {
          background-color: @rosewater;
          color: @base;
      }
      #pulseaudio.muted {
          background-color: @surface0;
          color: @rosewater;
      }

    '';
    settings = [{
      height = 20;
      layer = "bottom";
      position = "top";
      tray = { spacing = 10; };
      mode = "dock";
      modules-center = [ "clock" ];
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-right =
        [ "tray" "pulseaudio" "cpu" "memory" "temperature" "battery" ];
      battery = {
        format = "{capacity}% {icon}";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% ";
        format-icons = [ "" "" "" "" "" ];
        format-plugged = "{capacity}% ";
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock = {
        format = "{:%Y-%m-%d | %H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        interval = 2;
        format = " {usage}%";
        tooltip = false;
      };
      memory = { format = " {}%"; };
      network = {
        interval = 1;
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "Disconnected ⚠";
        format-ethernet =
          "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-wifi = "{essid} ({signalStrength}%) ";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = [ "" "" "" ];
          handsfree = "";
          headphones = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        on-click = "pavucontrol";
      };
      "sway/mode" = { format = ''<span style="italic">{}</span>''; };
      temperature = {
        critical-threshold = 80;
        format = " {temperatureC}°C";
        format-icons = [ "" ];
      };
    }];
  };

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
        "Print" = "exec ''grim -g \"$(slurp)\" - | wl-copy -t image/png''";
        "Alt+Print" = "exec ''grim - | wl-copy -t image/png''";
      };
      startup = [
        { command = "picom"; }
        { command = "blueman-applet"; }
        { command = "nm-applet --indicator"; }
        { command = "kdeconnect-indicator"; }
        { command = "keepassxc"; }
        { command = "keepassxc"; }
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

  services.syncthing.enable = true;
  #
  services.mpris-proxy.enable = true;

  services.network-manager-applet.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
