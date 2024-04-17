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

  programs.emacs = {
    enable = true;
    package = (pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      defaultInitFile = true;
      # config = path/to/your/config.org; # Org-Babel configs also supported

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages = epkgs: [ epkgs.use-package ];

      # Optionally override derivations.
      override = epkgs:
        epkgs // {
          somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old:
            {
              # Apply fixes here
            });
        };
    });
  };
  #programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacs29-pgtk;
  #  };
  #  home.file.".emacs.d" = {
  #    source = ./emacs.d;
  #    recursive = true;
  #  };
}
