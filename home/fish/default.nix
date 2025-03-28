{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      ${pkgs.pfetch-rs}/bin/pfetch
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      {
        name = "grc";
        inherit (pkgs.fishPlugins.grc) src;
      }
    ];
  };
}
