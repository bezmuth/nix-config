# common config between "all" (roshar and mishim) devices

{ config, pkgs, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in {
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

  #boot.kernelPackages = pkgs.linuxPackages_zen; #migth cause crashes with vlc
  #
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  networking.networkmanager.enable = true;
  # hellsite bloce
  networking.extraHosts = ''
    127.0.0.1 twitter.com
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

  programs.wireshark.enable = true;

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

  services.blueman.enable = true;

  boot.cleanTmpDir = true;
  #boot.plymouth.enable = true;

  users.defaultUserShell = pkgs.nushell;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bezmuth = {
    isNormalUser = true;
    description = "Bezmuth";
    extraGroups =
      [ "networkmanager" "wheel" "adbusers" "video" "wireshark" "libvirtd" ];
    packages = with pkgs; [ ];

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.libvirtd.enable = true;

  programs.kdeconnect.enable = true;
  # programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  programs.adb.enable = true;
  programs.steam.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.fwupd.enable = true;
  services.ratbagd.enable = true;

  networking.firewall.checkReversePath = "loose";
  #services.tailscale.enable = true;
  services.openssh.enable = true;
  programs.firejail.enable = true;
  networking.nftables.enable = true;
  services.opensnitch = {
    enable = true;
    settings = {
      Firewall = "nftables";
      DefaultAction = "deny";
    };
  };
  # load tskey secret
  age.secrets.tskey.file = ./secrets/tskey.age;
  #systemd.services.tailscale-autoconnect = {
  #  description = "Automatic connection to Tailscale";
  #
  #   # make sure tailscale is running before trying to connect to tailscale
  #  after = [ "network-pre.target" "tailscale.service" ];
  # wants = [ "network-pre.target" "tailscale.service" ];
  # # wantedBy = [ "multi-user.target" ];

  # # set this service as a oneshot job
  #  serviceConfig.Type = "oneshot";

  # have the job run this shell script
  #script = with pkgs; ''
  #  # wait for tailscaled to settle
  #  sleep 2

  # check if we are already authenticated to tailscale
  # status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
  #if [ $status = "Running" ]; then # if so, then do nothing
  # exit 0
  #fi

  # # otherwise authenticate with tailscale
  # ${tailscale}/bin/tailscale up -authkey file:${config.age.secrets.tskey.path}
  #   '';
  #};
  #
  services.xserver.windowManager.i3.enable = true;
  security.polkit.enable = true;
  programs.light.enable = true;

  programs.dconf.enable = true;
  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.kanshi}/bin/kanshi -c /home/bezmuth/.config/kanshi/config";
    };
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  documentation.dev.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ispell
    kanshi
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
    gnomeExtensions.blur-my-shell
    webcamoid
    man-pages
    man-pages-posix
    veracrypt
    sccache
    alacritty # gpu accelerated terminal
    rofi
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    papirus-icon-theme
    #gnome3.adwaita-icon-theme # default gnome cursors
    swaylock
    swayidle
    flameshot
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    #mako # notification system developed by swaywm maintainer
    #  thunderbird
    wireshark
    virt-manager
    sniffnet
  ];
}
