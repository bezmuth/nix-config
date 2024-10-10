{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "bezmuth";
    homeDirectory = "/home/bezmuth";
    shellAliases = {
      rb = "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
      ub = "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
    };
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      wine64
      kdePackages.ark
      distrobox
      gparted
      firefox
      keepassxc
      protonvpn-gui
      vlc
      libreoffice-fresh
      nixfmt-classic
      anki-bin
      tor-browser-bundle-bin
      piper
      htop
      r2modman
      ckan
      vscode
      boxbuddy
      inputs.remarkable-utility.packages.${system}.default
      osu-lazer-bin
    ];
  };

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;
}
