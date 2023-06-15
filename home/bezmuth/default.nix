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
  dconf.enable = true;

  services.syncthing.enable = true;

  services.opensnitch-ui.enable = true;
  #
  services.mpris-proxy.enable = true;

  services.network-manager-applet.enable = true;

}
