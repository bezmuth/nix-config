{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs = {
    ssh.startAgent = true;
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
      completion.enable = true;
      shellAliases = {
        rb = "cd ~/nix-config/ && nix develop --command bash -c 'rebuild'";
        ub = "cd ~/nix-config/ && nix develop --command bash -c 'upbuild'";
      };
      interactiveShellInit = "${pkgs.pfetch-rs}/bin/pfetch";
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$all"
          "$nix_shell"
        ];
        scan_timeout = 10;
        character = {
          success_symbol = "➜(bold green)";
          error_symbol = "➜(bold red)";
        };
        git_branch = {
          ignore_branches = [
            "master"
            "main"
          ];
        };
        nix_shell = {
          format = "❄ [(($name))](bold blue) ";
        };
      };
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
