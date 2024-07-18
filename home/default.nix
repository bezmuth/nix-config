{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./kitty
    ./zathura
    ./emacs
    ./bezmuth
    ./starship
    ./bash
    ./plasma
    ./spicetify
    ./fastfetch
    ./zellij
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
