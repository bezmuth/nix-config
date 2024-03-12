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
  ];

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
