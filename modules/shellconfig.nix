{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.bzm.shellconfig = {
    enable = mkEnableOption "Configure shell";
  };
  config = mkIf config.bzm.shellconfig.enable {
    programs = {
      fish.enable = true;
      fish.shellInit = "set fish_greeting";
      bash = {
        completion.enable = true;
        shellAliases = {
          rb = "cd ~/nix-config/ && nix develop --command bash -c 'rebuild'";
          ub = "cd ~/nix-config/ && nix develop --command bash -c 'upbuild'";
        };
        interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
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
  };
}
