{ config, pkgs, lib, inputs, ... }:

{
  programs.spicetify = {
    enable = true;
    theme =
      inputs.spicetify-nix.packages.${pkgs.system}.default.themes.catppuccin-mocha;
    colorScheme = "flamingo";

    enabledExtensions =
      with inputs.spicetify-nix.packages.${pkgs.system}.default.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        keyboardShortcut
        popupLyrics
        playlistIcons
        genre
        playNext
        volumePercentage
      ];
  };
}
