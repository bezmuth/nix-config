{ config, pkgs, lib, inputs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacs; # emacs pgtk blocks cause irony-el is kinda fucky
  };
  #  programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacs29-pgtk;
  #  };
  #  home.file.".emacs.d" = {
  #    source = ./emacs.d;
  #    recursive = true;
  #  };
}
