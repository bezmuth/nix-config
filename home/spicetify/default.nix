{ config, pkgs, lib, inputs, ... }:

{
  programs.spicetify = {
    enable = true;
    theme =
      inputs.spicetify-nix.packages.${pkgs.system}.default.themes.catppuccin;
    colorScheme = "flamingo";

    enabledExtensions =
      with inputs.spicetify-nix.packages.${pkgs.system}.default.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        keyboardShortcut
        popupLyrics
        playlistIcons
        playNext
        volumePercentage
        lastfm
        songStats
      ];
  };
}
