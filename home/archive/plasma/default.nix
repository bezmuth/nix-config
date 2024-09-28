{ config, pkgs, lib, inputs, ... }: {
  home.packages = with pkgs; [ dolphin kdePackages.plasma-browser-integration ];
}
