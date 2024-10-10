{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  programs.nushell = {
    enable = true;
    configFile.source = ./nu.nu;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableNushellIntegration = true;

}
