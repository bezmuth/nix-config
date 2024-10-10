# See: https://github.com/sebnyberg/doomemacs-nix-example
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    pandoc
    nixfmt
    plantuml
    graphviz
    texliveSmall
    aspell
    ripgrep
    # Indexing / search dependencies
    fd
    (ripgrep.override { withPCRE2 = true; })

    # Font / icon config
    # Added FiraCode as an example, it's not used in the config example.
    emacs-all-the-icons-fonts
    fontconfig

    sqlite
    zls
    rust-analyzer
  ];

  # Note that session variables and path can be a bit wonky to get going. To be
  # on the safe side, logging out and in again usually works.
  # Otherwise, to fast-track changes, run:
  # . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  home.sessionVariables = {
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs29-pgtk;

  # Note! This must match $DOOMDIR
  xdg.configFile."doom".source = ./doom;

  # Note! This must match $EMACSDIR
  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "c8a5e6ec1ca85a35f94d6c820c2fd8888373c2ae";
  };

}
