{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  home.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake /home/bezmuth/nix-config/.";
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsNativeComp;
  };

  programs.zsh = {
    enable = true; # Your zsh config
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv"];
      theme = "af-magic";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
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
    spotify
    discord
    protonvpn-gui
    pandoc # emacs
    nixfmt # emacs
    lorri
    element-desktop
    prismlauncher
    nodejs
    bat
    qbittorrent
    vlc
    libreoffice-fresh
    scrcpy
    rsync
    nixfmt
    anki-bin
    tribler
    plantuml
    graphviz
    texlive.combined.scheme-full
    tor-browser-bundle-bin
    tootle
    veracrypt
    piper
    gnome-feeds
    calibre
    sway
    grim
    mitmproxy
  ];

  services.blueman-applet.enable = true;

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

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty";
      keybindings = let
        m = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${m}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
          "${m}+space" = "exec dmenu_run";
          "${m}+t" = "split toggle";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          # screenshots
          "Print" = "exec ''grim -g \"$(slurp)\" - | wl-copy -t image/png''";
          "Alt+Print" = "exec ''grim - | wl-copy -t image/png''";
        };

      gaps = {
        smartBorders = "on";
        outer = 5;
        inner = 5;
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
        };
      };

      output."*".bg = "~/Pictures/GeminidoverBluemoonvalley-2000.jpg fill";

    };
  };

  services.syncthing.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
