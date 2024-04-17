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

  services.opensnitch = {
    enable = false;
    settings = {
      Firewall = "nftables";
      DefaultAction = "deny";
    };
  };
  services.openssh.enable = true;

  #virtualisation.docker.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.fwupd.enable = true;
  services.ratbagd.enable = true;

  #services.blueman.enable = true;

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        user = "bezmuth";
        command = "${pkgs.hyprland}/bin/Hyprland";
      };
    };
  };

  # plasma 6 testing
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

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

  programs.alvr.enable = true;
  programs.noisetorch.enable = true;

}
