# common config between "all" (roshar and mishim) devices

{ config, pkgs, inputs, ... }: {
  imports = [ ./services.nix ./programs.nix ./flatpak.nix ];
  # Point nix path to the home dir
  nix = {
    # set nix path properly
    nixPath = [
      "nixos-config=/home/bezmuth/nix-config/flake.nix"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.utf8";
  console.keyMap = "uk";
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.vulkan-validation-layers ];
  };
  boot.tmp.cleanOnBoot = true;
  users.defaultUserShell = pkgs.bash;
  users.users.bezmuth = {
    isNormalUser = true;
    description = "Bezmuth";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "video"
      "wireshark"
      "libvirtd"
      "docker"
    ];
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libusb ];
  security.polkit.enable = true;
  documentation.dev.enable = true;
  security.sudo-rs.enable = true;
}
