{ config, pkgs, lib, inputs, ... }:

{

  imports =
    [ ./hyprland ./kitty ./zathura ./spicetify ./emacs ./bezmuth ./starship ];

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
