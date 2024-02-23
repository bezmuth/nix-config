{ config, pkgs, lib, inputs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [ "$all" "$nix_shell" ];
      scan_timeout = 10;
      character = {
        success_symbol = "➜(bold green)";
        error_symbol = "➜(bold red)";
      };
      git_branch = { ignore_branches = [ "master" "main" ]; };
      nix_shell = { format = "❄ [(($name))](bold blue) "; };
    };
  };
}
