{ config, pkgs, lib, inputs, ... }: {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = ./config;
  };
  home.packages = with pkgs; [ socat acpi swayosd pamixer jq ];
}
