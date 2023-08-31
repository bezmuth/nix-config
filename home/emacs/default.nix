{ config, pkgs, lib, inputs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacs29-pgtk;
  };

}
