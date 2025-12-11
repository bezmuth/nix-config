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

  bzm = {
    common.enable = true;
    hardening.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
