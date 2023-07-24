{ config, pkgs, lib, inputs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    temurin-jre-bin-18
    xorg.xhost
    gparted
    webcord-vencord
    swaybg
    w3m
    firefox
    syncthing
    keepassxc
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
    gnome-solanum
    calibre
    grim
    slurp
    wl-clipboard
    mitmproxy
    font-awesome
    playerctl
    chromium
    gnome.cheese
    newsflash
    ranger
    tmux
    pavucontrol
    pulseaudio
    networkmanagerapplet
    nerdfonts
    catppuccin-cursors
    i2p
    transmission-gtk
    pcmanfm
    haruna
    gqrx
    kiwix
    picom
    htop
    fortune
    cowsay
    lolcat
    teams-for-linux
    swaylock
    spot
    xcowsay
  ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors;
    name = "mochaLite";
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    theme = {
      name = "Catppuccin-Mocha-Compact-Pink-dark";
      package = pkgs.catppuccin-gtk.override { variant = "mocha"; };
    };
  };

  dconf.enable = true;

  services.syncthing.enable = true;

  services.opensnitch-ui.enable = true;
  #
  services.mpris-proxy.enable = true;

  services.network-manager-applet.enable = true;

}
