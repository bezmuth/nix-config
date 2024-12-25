{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./services.nix];
  services.openssh.enable = true;
}
