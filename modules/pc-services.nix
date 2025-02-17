{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./services.nix
  ];
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.pulseaudio.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  security.pam.sshAgentAuth.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  services = {
    power-profiles-daemon.enable = true;
    ratbagd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    desktopManager.plasma6.enable = true;
    # lightdm
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
    };
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "bezmuth";
      sddm.enable = true;
    };
    xserver.excludePackages = [pkgs.xterm];
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
  };
}
