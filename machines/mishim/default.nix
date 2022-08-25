# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, agenix, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  # Point nix path to the home dir
  #
  # The simplest way to bootstrap this would be to use a symbolic link initially
  nix.nixPath = ["nixos-config=/home/bezmuth/nix-config/configuration.nix"
                 "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" ];

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
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


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "Mishim"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };
  console.keyMap = "uk";
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # set default shell
  users.defaultUserShell = pkgs.zsh;

  users.users.bezmuth = {
    isNormalUser = true;
    description = "Bezmuth";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
  };

  # clean /tmp at boot
  boot.cleanTmpDir = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "bezmuth";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gnome-solanum
    gnomeExtensions.appindicator
    gnomeExtensions.runcat
    gnomeExtensions.gsconnect
    gnomeExtensions.nasa-apod
    gnomeExtensions.syncthing-indicator
  ];
  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  services.openssh.enable = true;

  # load tskey secret
  age.secrets.tskey.file = ../../secrets/tskey.age;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey file:${config.age.secrets.tskey.path}
    '';
  };


  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  programs.adb.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Nix flakes
  system.stateVersion = "22.05"; # Did you read the comment?

}
