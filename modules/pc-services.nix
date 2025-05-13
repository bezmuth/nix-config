{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  security.pam.sshAgentAuth.enable = true;
  security.rtkit.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services = {
    power-profiles-daemon.enable = true;
    ratbagd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
    };
    greetd = {
      package = pkgs.greetd.tuigreet;
      enable = true;
      settings = rec {
        initial_session = {
          command = "sway --unsupported-gpu";
          user = "bezmuth";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --asterisks --cmd 'sway --unsupported-gpu'";
        };
      };
    };
    xserver.excludePackages = [ pkgs.xterm ];
    # Configure keymap in X11
    xserver.xkb = {
      layout = "gb";
      variant = "";
    };
    # mount external devices
    gvfs.enable = true;
    udisks2.enable = true;
    avahi.publish.enable = true;
    avahi.publish.userServices = true;
    printing.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
