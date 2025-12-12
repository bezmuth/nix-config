{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.bzm.sway = {
    enable = mkEnableOption "Enable sway + support programs";
  };

  config = mkIf config.bzm.sway.enable {
    environment.systemPackages = with pkgs; [
      mate.engrampa
      mate.eom
      zip
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      alacritty
      wmenu
      playerctl
      networkmanagerapplet
      blueman
      pcmanfm
      light
      autotiling-rs
      brightnessctl
    ];
    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraOptions = [ "--unsupported-gpu" ];
      };
      dconf.enable = true;
      xwayland.enable = true;
      kdeconnect.enable = true;
      xfconf.enable = true;
    };
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "sway";
          user = "bezmuth";
        };
        default_session = initial_session;
      };
    };
  };
}
