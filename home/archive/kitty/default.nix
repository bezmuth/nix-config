{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    shellIntegration.enableBashIntegration = true;
  };
}
