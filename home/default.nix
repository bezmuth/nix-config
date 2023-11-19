{ config, pkgs, lib, inputs, ... }:

{

  imports =
    [ ./hyprland ./nushell ./kitty ./zathura ./spicetify ./emacs ./bezmuth ];

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
