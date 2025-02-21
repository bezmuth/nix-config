# See: https://github.com/sebnyberg/doomemacs-nix-example
{
  config,
  pkgs,
  ...
}: {
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
    # Note that session variables and path can be a bit wonky to get going. To be
    # on the safe side, logging out and in again usually works.
    # Otherwise, to fast-track changes, run:
    # . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
    };
    sessionPath = ["${config.xdg.configHome}/emacs/bin"];
  };
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs29-pgtk;

  # Note! This must match $DOOMDIR
  xdg.configFile."doom".source = ./doom;

  # Note! This must match $EMACSDIR
  #xdg.configFile."emacs".source = builtins.fetchGit {
  #  url = "https://github.com/doomemacs/doomemacs.git";
  #  rev = "ba1dca322f9a07bc2b7bec6a98f2c3c55c0bbd77";
  #};
}
