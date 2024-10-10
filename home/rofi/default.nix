{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-power-menu ]; };
    extraConfig = {
      modi = "run,drun,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      terminal = "alacritty";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "  Apps ";
      display-run = "  Run ";
      display-Power-menu = "  Power";
      sidebar-mode = true;
    };
    theme = ./rofi-catppuccin.rasi;
  };

}
