{ config, pkgs, lib, inputs, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Latte";
    shellIntegration.enableBashIntegration = true;
  };
}
