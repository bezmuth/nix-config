{ config, pkgs, lib, inputs, ... }:

{

  programs.nushell = {
    enable = true;
    configFile.source = ./nu.nu;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableNushellIntegration = true;

}
