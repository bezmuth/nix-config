{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        ${pkgs.pfetch-rs}/bin/pfetch
        alias rb=cd ~/nix-config/ && nix develop --command bash -c 'rebuild'
        alias rb=cd ~/nix-config/ && nix develop --command bash -c 'upbuild'
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
    vim
    git
    man-pages
    man-pages-posix
    veracrypt
    xdg-utils # for openning default programms when clicking links
  ];
}
