# common config between "all" (roshar and mishim) devices

{ config, pkgs, ... }:

{
  imports = [ ./services.nix ./programs.nix ];
  # Point nix path to the home dir
  nix = {
    # set nix path properly
    nixPath = [
      "nixos-config=/home/bezmuth/nix-config/flake.nix"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc.automatic = true;
    gc.dates = "19:00";
    gc.persistent = true;
    gc.options = "--delete-older-than 14d";

    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  networking.networkmanager.enable = true;
  # hellsite block
  networking.extraHosts = ''
    127.0.0.1 twitter.com
  '';
  networking.firewall.checkReversePath = "loose";

  # Set your time zone.
  time.timeZone = "Europe/London";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";
  # Configure console keymap
  console.keyMap = "uk";

  hardware.opengl.enable = true;

  boot.cleanTmpDir = true;

  users.defaultUserShell = pkgs.nushell;
  users.users.bezmuth = {
    isNormalUser = true;
    description = "Bezmuth";
    extraGroups =
      [ "networkmanager" "wheel" "adbusers" "video" "wireshark" "libvirtd" ];
    packages = with pkgs; [ ];

  };

  security.polkit.enable = true;

  documentation.dev.enable = true;

}
