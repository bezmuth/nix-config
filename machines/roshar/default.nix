# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "Roshar"; # Define your hostname.

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.cpu.intel.updateMicrocode = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # true breaks hardware video decode (i think)
  };

  system.stateVersion = "22.05"; # Did you read the comment?

  environment.variables = rec { STEAM_FORCE_DESKTOPUI_SCALING = "1.75"; };

  # Nvidia Hardware decoding

}
