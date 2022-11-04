{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  home.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake /home/bezmuth/nix-config/.";
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsNativeComp;
  };

  programs.zsh = {
    enable = true; # Your zsh config
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv"];
      theme = "af-magic";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    firefox
    syncthing
    keepassxc
    spotify
    discord
    protonvpn-gui
    pandoc # emacs
    nixfmt # emacs
    lorri
    element-desktop
    prismlauncher
    nodejs
    bat
    qbittorrent
    vlc
    libreoffice-fresh
    scrcpy
    rsync
    nixfmt
    anki-bin
    tribler
    plantuml
  ];

  services.syncthing.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
