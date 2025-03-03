# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "Roshar"; # Define your hostname.
  environment.systemPackages = with pkgs; [
    tuxclocker # nvidia overclocking
    nvtopPackages.full
  ];

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    cpu.intel.updateMicrocode = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
      open = true;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  system.stateVersion = "22.05"; # Did you read the comment?

  environment.variables = rec {};

  #deadlock
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };
}
