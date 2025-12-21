# See: https://github.com/sebnyberg/doomemacs-nix-example
{
  pkgs,
  ...
}:
{
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    emacs = pkgs.emacs-pgtk;
    experimentalFetchTree = true;
    # https://github.com/NixOS/nixpkgs/pull/472609
    #extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
  home = {
    packages = with pkgs; [
      pandoc
      plantuml
      graphviz
      texliveSmall
      aspell
      ripgrep
      # Indexing / search dependencies
      fd
      (ripgrep.override { withPCRE2 = true; })
      emacs-all-the-icons-fonts
      fontconfig
      sqlite
      zls
      rust-analyzer
      jdt-language-server
      openjdk
      maven
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      gcc
      w3m
      # babel
      go
    ];
  };
}
