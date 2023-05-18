{ config, pkgs, lib, inputs, ... }:

{

  imports = [ ./hyprland ./nushell ];
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

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    spotify
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
    fortune
    cowsay
    lolcat
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
    enable = false;
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

  services.syncthing.enable = true;

  services.opensnitch-ui.enable = true;
  #
  services.mpris-proxy.enable = true;

  services.network-manager-applet.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
