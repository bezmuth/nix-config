{ config, pkgs, lib, inputs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "bezmuth";
    homeDirectory = "/home/bezmuth";
    shellAliases = {
      rb =
        "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
      ub =
        "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
    };
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
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
      gpodder
      lem
      ckan
    ];
  };
  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;
}
