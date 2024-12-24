{pkgs, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    man-pages
    man-pages-posix
    veracrypt
    xdg-utils # for openning default programms when clicking links
  ];
}
