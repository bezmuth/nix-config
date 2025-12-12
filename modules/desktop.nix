{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.bzm.desktop = {
    enable = mkEnableOption "Enable desktop features and programs";
  };

  config = mkIf config.bzm.desktop.enable {
    # Programs
    environment.systemPackages = with pkgs; [
      (catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        variant = "mocha";
      })
      tuba
      tor-browser
      mpv
      ispell
      nextcloud-client
      webcord-vencord
      thunderbird
      protonmail-bridge
      android-studio
      proton-pass
      protonvpn-gui
      gparted
      anki-bin
      libreoffice-fresh
      powertop
      transmission-remote-gtk
      transmission_4-gtk
      dino
      proton-pass
      anki-bin
      kiwix
      koreader
    ];
    fonts.packages =
      with pkgs;
      [
        iosevka
        font-awesome
        emacs-all-the-icons-fonts
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    # Services
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services = {
      power-profiles-daemon.enable = true;
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      # mount external devices
      gvfs.enable = true;
      udisks2.enable = true;
      avahi.publish.enable = true;
      avahi.publish.userServices = true;
      printing.enable = true;
      gnome.gnome-keyring.enable = true;
    };
  };
}
