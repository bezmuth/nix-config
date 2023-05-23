{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  virtualisation.libvirtd.enable = true;

  programs.xwayland.enable = true;

  programs.wireshark.enable = true;

  programs.kdeconnect.enable = true;

  programs.adb.enable = true;

  programs.steam.enable = true;

  programs.firejail.enable = true;

  programs.light.enable = true;

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    swaybg
    ispell
    kanshi
    firefox
    keepassxc
    vim
    bat
    git
    lm_sensors
    gnome-solanum
    webcamoid
    man-pages
    man-pages-posix
    veracrypt
    sccache
    alacritty # gpu accelerated terminal
    rofi
    sway
    wayland
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    papirus-icon-theme
    #gnome3.adwaita-icon-theme # default gnome cursors
    swaylock
    swayidle
    flameshot
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    #mako # notification system developed by swaywm maintainer
    #  thunderbird
    wireshark
    virt-manager
    sniffnet
    wdisplays
    w3m
  ];

}
