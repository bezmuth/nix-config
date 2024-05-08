{ config, pkgs, lib, inputs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    distrobox
    temurin-jre-bin-18
    xorg.xhost
    gparted
    webcord-vencord
    swaybg
    firefox
    keepassxc
    protonvpn-gui
    lorri
    prismlauncher
    vlc
    libreoffice-fresh
    nixfmt-classic
    anki-bin
    tor-browser-bundle-bin
    piper
    chromium
    nnn
    tmux
    catppuccin-cursors
    transmission-gtk
    htop
    beeper
    r2modman
    nextcloud-client
  ];

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;
}
