{ config, pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.dbus.enable = true;
  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.kanshi}/bin/kanshi -c /home/bezmuth/.config/kanshi/config";
    };
  };

  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.fwupd.enable = true;
  services.ratbagd.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.printing.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # plasma 6 testing
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.konsole
    pkgs.kdePackages.elisa
    pkgs.kdePackages.kate
    pkgs.kdePackages.okular
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  # mount external devices
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so

    # Password management.
    password sufficient pam_unix.so nullok sha512

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  # System wide adblock
  networking.nameservers = [ "127.0.0.1" ];
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.plus.txt"
          ];
        };
        #Configure what block categories are used
        clientGroupsBlock = { default = [ "ads" "twitter" "reddit" ]; };
      };
      caching = {
        minTime = "5m";
        maxTime = "15m";
        prefetching = true;
      };
    };
  };
  virtualisation.podman.enable = true;
}
