{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
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
