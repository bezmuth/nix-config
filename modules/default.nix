# common config between "all" (roshar and mishim) devices
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./programs.nix
    ./services.nix
  ];
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
        "https://microvm.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
      ];
    };
    package = pkgs.nixVersions.stable; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  hardware.graphics.enable = true;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };
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
      "i2c"
    ];
  };
  documentation.dev.enable = true;

  security = {
    polkit.enable = true;
    sudo.enable = false;
    wrappers = {
      su.setuid = lib.mkForce false;
      sg.setuid = lib.mkForce false;
      fusermount.setuid = lib.mkForce false;
      fusermount3.setuid = lib.mkForce false;
      mount.setuid = lib.mkForce false;
      umount.setuid = lib.mkForce false;
      pkexec.setuid = lib.mkForce false;
      newgrp.setuid = lib.mkForce false;
      newgidmap.setuid = lib.mkForce false;
      newuidmap.setuid = lib.mkForce false;
      chsh.setuid = lib.mkForce false;
    };
    pki.certificates = [
      ''
        -----BEGIN CERTIFICATE-----
        MIICWTCCAUGgAwIBAgIRAMXiExlrYsgpbDun5CkgQHAwDQYJKoZIhvcNAQELBQAw
        EDEOMAwGA1UEAwwFdHNfY2EwHhcNMjUxMjA2MDgzODEzWhcNMjUxMjEzMDgzODEz
        WjAjMSEwHwYDVQQDDBh0c19jYSAtIEVDQyBJbnRlcm1lZGlhdGUwWTATBgcqhkjO
        PQIBBggqhkjOPQMBBwNCAAS3ydfRHSUwqY05K74fnUgxMqpzOV4qg6Gcjgm0MD+/
        VcO4Ig+CWce0+SBvOvaSraBC1H1cZIfSRHUg1l9DLlhgo2YwZDAOBgNVHQ8BAf8E
        BAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUey+RoNQjj+YmnThK
        qr/yZY0xQgEwHwYDVR0jBBgwFoAUHOJM3ZWbeiZPvS+dIlc00TEP2eQwDQYJKoZI
        hvcNAQELBQADggEBAIBwqjZ7G9/+SfHsclRogHrTlONb9oL3cHv6qE+QcpcB2hRD
        FVs0m6NGGxyvLQ/ZIjzxsDa0cWfMJsP8p72xw3p85SVz8uM4eW88hWBc1K9MZz6K
        hkD5tVWePoNbKegl98qkA6R1jb0jym/pJjBcjOIosxbKuDlSTQdLG+kEwOeWwzf6
        lCxWVi4i2G1a0XTUE8D3JiG/GiDap9hLRrh7eKvKkf5qReC/6MfAtCD+4ttSNbRN
        0141D8NBuu8Or+UTRzBIZ6158ECYmalhNtD86Ckx58xQT6NdPrFcI5bfaJctPWlK
        np86RQupqlltsz7MKq7jfybv4hAAPW3sdJi/RYA=
        -----END CERTIFICATE-----
      ''
    ];
  };
}
