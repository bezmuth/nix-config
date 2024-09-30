{ config, pkgs, lib, inputs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = { right = 1; };
      };
      display = {
        size.binaryPrefix = "si";
        color = "blue";
        separator = "  ";
      };
      modules = [ "OS" "Packages" "Kernel" "CPUUsage" "Disk" ];
    };
  };
  #programs.bash.bashrcExtra = "fastfetch";
}
