# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9c0a10d0-2718-41f7-a40c-b781bf68b5cc";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/85EB-F142";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/148843ad-f1f6-46c3-ab75-5294eb7e7529"; }
  ];

  fileSystems."/run/media/bezmuth/564b6e1c-ed35-4593-afcd-149bfbc56ed0" = {
    device = "/dev/disk/by-uuid/564b6e1c-ed35-4593-afcd-149bfbc56ed0";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      "exec"
      "auto"
    ];
  };

  fileSystems."/run/media/bezmuth/71d08765-4ea9-4cb5-9508-445173afd301" = {
    device = "/dev/disk/by-uuid/71d08765-4ea9-4cb5-9508-445173afd301";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      "exec"
      "auto"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
