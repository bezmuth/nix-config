{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  programs.xwayland.enable = true;
  programs.kdeconnect.enable = true;
  programs.adb.enable = true;
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    fontPackages = [ pkgs.corefonts pkgs.vistafonts ];
  };
  programs.light.enable = true;
  programs.dconf.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "pink" ];
      winDecStyles = [ "modern" ];
    })
    (papirus-icon-theme.override { color = "pink"; })
    (catppuccin-gtk.override {
      accents = [ "pink" ];
      size = "compact";
      variant = "mocha";
    })
    adwaita-icon-theme
    mpv
    ispell
    vim
    bat
    git
    webcamoid
    man-pages
    man-pages-posix
    veracrypt
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    minecraft
    pulseaudio
  ];

  fonts.packages = with pkgs; [
    iosevka
    font-awesome
    nerdfonts
    emacs-all-the-icons-fonts
  ];

}
