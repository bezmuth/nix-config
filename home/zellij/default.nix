{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}
