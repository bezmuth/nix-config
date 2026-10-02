{
  pkgs,
  ...
}:
let
  kernel_version = "7.2.8";
  mishim_kernel =
    (pkgs.linuxManualConfig {
      version = kernel_version;
      src = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${kernel_version}.tar.xz";
        hash = "sha256-EujVqXPRrXxaXGmILkAisTHtcV23AD/c12Dd+MPlGUE=";
      };

      configfile = ./kernel-config;
      allowImportFromDerivation = true;

      extraMakeFlags = [
        "KCFLAGS=-march=znver2 -mtune=znver2"
      ];
    }).overrideAttrs
      (old: {
        passthru = (old.passthru or { }) // {
          features = (old.passthru.features or { }) // {
            efiBootStub = true;
            netfilterRPFilter = true;
            ia32Emulation = true;
          };
        };
      });
in
{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  networking.hostName = "Mishim"; # Define your hostname.
  networking.modemmanager.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
  };

  boot.kernelPackages = pkgs.linuxPackagesFor mishim_kernel;

  bzm = {
    common.enable = true;
    hardening.enable = true;
    gaming.enable = true;
    shellconfig.enable = true;
    desktop.enable = true;
    virtualisation.enable = true;
    sway.enable = true;
  };

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      enable_subtitles = "yes";
      media_dir = [ "/srv/minidlna" ];
    };
  };

  services.i2p.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?
}
