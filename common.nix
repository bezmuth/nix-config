# common config between "all" (roshar and mishim) devices

{ config, pkgs, ... }:

{
  # Point nix path to the home dir
  nix = {
    # set nix path properly
    nixPath = ["nixos-config=/home/bezmuth/nix-config/flake.nix"
               "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" ];
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

  boot.kernelPackages = pkgs.linuxPackages_6_0;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
  127.0.0.1 youtube.com
  127.0.0.1 twitter.com
  127.0.0.1 reddit.com
  '';

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };
  
  hardware.opengl.enable = true;
  programs.xwayland.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  boot.cleanTmpDir = true;

  users.defaultUserShell = pkgs.bash;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bezmuth = {
    isNormalUser = true;
    description = "Bezmuth";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  programs.adb.enable = true;
  programs.steam.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.fwupd.enable = true;

  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  services.openssh.enable = true;
  # load tskey secret
  age.secrets.tskey.file = ./secrets/tskey.age;
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
  #   '';
  };

  documentation.dev.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    firefox
    keepassxc
    vim
    bat
    git
    lm_sensors
    gnome-solanum
    gnomeExtensions.appindicator
    gnomeExtensions.runcat
    gnomeExtensions.gsconnect
    gnomeExtensions.nasa-apod
    gnomeExtensions.syncthing-indicator
    webcamoid
    man-pages
    man-pages-posix
    #  thunderbird
  ];
}
