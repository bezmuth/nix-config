{ config, pkgs, lib, inputs, ... }:

{

  imports =
    [ ./hyprland ./nushell ./alacritty ./zathura ./spicetify ./rofi ./emacs ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

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

  services.syncthing.enable = true;

  services.opensnitch-ui.enable = true;
  #
  services.mpris-proxy.enable = true;

  services.network-manager-applet.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
