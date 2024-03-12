{ config, pkgs, ... }:

{
  #nixpkgs.config.allowUnfree = true;

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
    catppuccin-kde
    gnome.adwaita-icon-theme
    cachix
    waypipe
    weston
    ispell
    vim
    bat
    git
    lm_sensors
    webcamoid
    man-pages
    man-pages-posix
    veracrypt
    sccache
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    papirus-icon-theme
    wireshark
    virt-manager
    wdisplays
    font-awesome
  ];

}
