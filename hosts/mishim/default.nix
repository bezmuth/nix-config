{
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "Mishim"; # Define your hostname.

  hardware = {
    cpu.amd.updateMicrocode = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
