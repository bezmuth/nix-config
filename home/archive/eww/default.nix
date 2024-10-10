{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ./config;
  };
  home.packages = with pkgs; [
    socat
    acpi
    swayosd
    pamixer
    jq
  ];
}
