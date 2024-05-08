{ modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable =
      true; # in case canTouchEfiVariables doesn't work for your system
    device = "nodev";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/628A-7F3B";
    fsType = "vfat";
  };
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
