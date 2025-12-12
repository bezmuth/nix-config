{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.bzm.gaming = {
    enable = mkEnableOption "Enable gaming features";
  };
  config = mkIf config.bzm.gaming.enable {
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        fontPackages = [
          pkgs.corefonts
          pkgs.vista-fonts
        ];
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      gamemode.enable = true;
      gamemode.enableRenice = true;
    };
    environment.systemPackages = with pkgs; [
      (catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        variant = "mocha";
      })
      temurin-jre-bin-17
      prismlauncher
      r2modman
      ares
      azahar
      heroic
      dolphin-emu
    ];
  };
}
