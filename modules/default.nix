# common config between "all" (roshar and mishim) devices
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ./gaming.nix
    ./hardening.nix
    ./shellconfig.nix
    ./desktop.nix
    ./sway.nix
    ./virtualisation.nix
    ../home
    ./flatpak.nix
    ./librewolf
  ];

  options.bzm.common = {
    enable = mkEnableOption "common config accross all systems";
  };

  config = mkIf config.bzm.common.enable {
    environment.systemPackages = with pkgs; [
      #inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      vim
      git
      man-pages
      man-pages-posix
      xdg-utils # for openning default programms when clicking links
      htop
      croc
      ripgrep
      nethogs
      cachix
    ];
    programs = {
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 5";
          dates = "12:00";
        };
      };
    };
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # enable wayland in electron apps (spotify)
        ANKI_WAYLAND = "1";
        WLR_RENDERER = "vulkan";
        PROTON_ENABLE_WAYLAND = "1";
      };
      localBinInPath = true;
    };
    services = {
      dbus.enable = true;
      upower.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
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
    };
    zramSwap.enable = true;
    systemd.oomd.enable = true;
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
        "i2c"
      ];
    };
    documentation.dev.enable = true;

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
      package = pkgs.nixVersions.latest; # or versioned attributes like nixVersions.nix_2_8
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
