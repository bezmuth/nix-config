{ config, pkgs, lib, inputs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    #emacsPackage = pkgs.emacs; # emacs pgtk blocks cause irony-el is kinda fucky
  };
  home.packages = with pkgs; [
    pandoc
    nixfmt
    plantuml
    graphviz
    texlive.combined.scheme-full
    font-awesome
  ];
  #programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacs29-pgtk;
  #  };
  #  home.file.".emacs.d" = {
  #    source = ./emacs.d;
  #    recursive = true;
  #  };
}
