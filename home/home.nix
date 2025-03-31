_: {
  imports = [
    ./bezmuth
    ./emacs
    ./zathura
    ./fish
    ./sway
    ./spicetify
    ./zellij
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
