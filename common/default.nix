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
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libusb ];
  security.polkit.enable = true;
  documentation.dev.enable = true;
  security.sudo-rs.enable = true;
}
