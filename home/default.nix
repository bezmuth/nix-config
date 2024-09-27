{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./zathura
    ./emacs
    ./bezmuth
    ./starship
    ./bash
    ./i3sway
    ./spicetify
    ./fastfetch
    ./zellij
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
