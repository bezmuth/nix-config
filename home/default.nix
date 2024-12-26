{...}: {
  imports = [
    ./emacs
    ./bezmuth
    ./zathura
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
