{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bezmuth";
  home.homeDirectory = "/home/bezmuth";

  home.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake /home/bezmuth/nix-config/.";
  };

  programs.zsh = {
    enable = true; # Your zsh config
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
      theme = "af-magic";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
    polymc
    nodejs
  ];

  services.syncthing.enable = true;

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
