{ config, pkgs, lib, inputs, ... }:

{
   home.packages = with pkgs; [
    pandoc
    nixfmt-classic
    plantuml
    graphviz
    texliveSmall
    font-awesome
    aspell
    ripgrep
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.org;
      defaultInitFile = true;
      alwaysTangle = true;
      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages = epkgs: [ epkgs.use-package ];
      alwaysEnsure = true;
      # Optionally override derivations.
      override = epkgs:
        epkgs // {
          somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old:
            {
              # Apply fixes here
            });
        };
    };
  };
}
