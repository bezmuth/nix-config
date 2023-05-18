{ config, pkgs, lib, inputs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsUnstable;
  };

}
