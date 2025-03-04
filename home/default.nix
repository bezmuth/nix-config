{...}: {
  imports = [
    ./bezmuth
    ./emacs
    ./zathura
    ./fish
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
