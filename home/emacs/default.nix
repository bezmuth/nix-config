# See: https://github.com/sebnyberg/doomemacs-nix-example
{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs = {
    emacs.enable = true;
    emacs.package = pkgs.emacs30-pgtk;
    # this is need for the sessionvariables to work with emacs
    bash.enable = true;
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
      (ripgrep.override {withPCRE2 = true;})
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
    ];
    sessionPath = ["${config.xdg.configHome}/emacs/bin"];

    # this can be messy, make sure you relog after first switch
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "$HOME/.local/share/doom";
      DOOMPROFILELOADFILE = "$HOME/.local/share/doom/profiles/load.el";
      # Get the miniflux fever token
      MINIFLUX_TOKEN = ''$(${pkgs.coreutils}/bin/cat ${config.age.secrets.miniflux-emacs-token.path})'';
    };
  };

  xdg.configFile."emacs".source = inputs.doom-emacs-src;
  xdg.configFile."doom".source = ./doom;
}
