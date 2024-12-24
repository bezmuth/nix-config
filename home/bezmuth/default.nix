{
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "bezmuth";
    homeDirectory = "/home/bezmuth";
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      wine64
      kdePackages.ark
      gparted
      firefox
      protonvpn-gui
      libreoffice-fresh
      anki-bin
      tor-browser-bundle-bin
      piper
      htop
      r2modman
      inputs.remarkable-utility.packages.${system}.default
    ];
  };

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;
}
