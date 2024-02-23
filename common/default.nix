# common config between "all" (roshar and mishim) devices

{ config, pkgs, inputs, ... }: {
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

  # needed for waypipe
  services.openssh.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.enableRedistributableFirmware = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];
  boot.plymouth = let
    plymouthTheme = pkgs.catppuccin-plymouth.override { variant = "mocha"; };
  in {
    enable = true;
    themePackages = [ plymouthTheme ];
    theme = "catppuccin-mocha";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # hellsite block
  networking.extraHosts = "";
  networking.firewall.checkReversePath = "loose";

  # Set your time zone.
  time.timeZone = "Europe/London";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";
  # Configure console keymap
  console.keyMap = "uk";

  hardware.opengl.enable = true;

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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3XWn0EIrX6rRWIIus4c0J3kt2iLKecfj21wbPD+tujIQXxTzBnkKlJE3o32/cvHGmETGozLI04NhXXAL1+mLoPLNIBEpRay2OZTu2/xzhnmN9YyI3QKaI+MmQnn+jZjWk/B9zIz6e9UihUrLFVVIXGci1n8ZT4sdv8Hir7+4u7sTw6kiOlp+ARjLZr8T1UrPR6KDpud/DxPRY2T5c2r89FUv9n9nBvJVWs20nQjeiGr+BXTlUiKl2x2MkE+lEk0rSqkKMfDmAFZNHpytpw9EB3fsw+omMlURHK8aZEi0H61ecFWXbFBF5VAtfjha9yedOR/TYeba4fTtomD1J5CP4qUyhzJrxxIWL7+rsR3dcFoXMDaOYjuc26XU8iCcAtXNuwpGdre5hYYqVQlETXjv8lVgNucwc7HZgLY0MfAo82FR17j7HPpAzOqDh7vISTwsq7bI9bIvQrq8EH3E6U+Lex7wNW9RCDOCJAey09cvksBPgLY3KvOU3n20p+9Qv7uE= bezmuth@fedora"
    ];
    packages = with pkgs; [ ];

  };

  security.polkit.enable = true;

  documentation.dev.enable = true;

}
