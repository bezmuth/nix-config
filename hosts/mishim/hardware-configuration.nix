# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "ehci_pci"
    "xhci_pci"
    "uas"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7d6177ec-46f1-4972-8cdd-9dab67913f47";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-92625fb6-9743-4a7a-8eb4-ba9507e8a79e".device = "/dev/disk/by-uuid/92625fb6-9743-4a7a-8eb4-ba9507e8a79e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8E7B-8107";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/e7846c64-324e-437e-a240-4b43fe4005b0";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-8e855ea8-071c-474e-8517-13fa470cf51c".device = "/dev/disk/by-uuid/8e855ea8-071c-474e-8517-13fa470cf51c";
}