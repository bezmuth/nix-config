# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/151fe5b5-61df-4e7a-8473-b2939a02fc37";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0646ec4e-4789-45bd-8ec8-f60ac8bbc0e1".device =
    "/dev/disk/by-uuid/0646ec4e-4789-45bd-8ec8-f60ac8bbc0e1";
  boot.initrd.luks.devices."luks-204a3273-cf89-4ae7-b3c1-747e05220fd5".device =
    "/dev/disk/by-uuid/204a3273-cf89-4ae7-b3c1-747e05220fd5";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3F82-B1C6";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/run/mount/SSD 2" = {
    device = "/dev/disk/by-uuid/25A1ECD023922BF6";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/cf2ad9a9-c73c-475d-a4f7-a4e40bd8adf6"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
