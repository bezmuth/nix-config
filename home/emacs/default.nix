{ config, pkgs, lib, inputs, ... }:

{
  # nix-doom-emacs is pretty much broken, Linked doom.d here to .doom.d
  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom.d;
  #   emacsPackage = pkgs.emacs28;
  # };
  home.file.".doom.d".source = config.lib.file.mkOutOfStoreSymlink ./doom.d;
  home.packages = with pkgs; [
    emacs29-pgtk
    pandoc
    nixfmt
    plantuml
    graphviz
    texliveSmall
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
