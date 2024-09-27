{ config, pkgs, lib, inputs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableNushellIntegration = true;
}
