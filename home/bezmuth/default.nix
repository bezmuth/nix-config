{ config, pkgs, lib, inputs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    hackgen-nf-font
    distrobox
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
    tor-browser-bundle-bin
    piper
    gnome-feeds
    gnome-solanum
    calibre
    mitmproxy
    chromium
    gnome.cheese
    newsflash
    ranger
    tmux
    pavucontrol
    pulseaudio
    catppuccin-cursors
    i2p
    transmission-gtk
    gqrx
    kiwix
    htop
    fortune
    cowsay
    lolcat
    teams-for-linux
    spot
    xcowsay
    beeper
    lutgen
    inputs.nh.packages.${pkgs.system}.default
  ];

  fonts.fontconfig.enable = true;

  dconf.enable = true;

  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;

  services.mpris-proxy.enable = true;

}
