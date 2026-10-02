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
    programs.nix-ld.enable = true;
    services.udev.extraRules = ''
      # This rule was added by Solaar.
      #
      # Allows non-root users to have raw access to Logitech devices.
      # Allowing users to write to the device is potentially dangerous
      # because they could perform firmware updates.

      ACTION == "remove", GOTO="solaar_end"
      SUBSYSTEM != "hidraw", GOTO="solaar_end"

      # USB-connected Logitech receivers and devices
      ATTRS{idVendor}=="046d", GOTO="solaar_apply"

      # Lenovo nano receiver
      ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6042", GOTO="solaar_apply"

      # Bluetooth-connected Logitech devices
      KERNELS == "0005:046D:*", GOTO="solaar_apply"

      GOTO="solaar_end"

      LABEL="solaar_apply"

      # Allow any seated user to access the receiver.
      # uaccess: modern ACL-enabled udev
      TAG+="uaccess"

      # Grant members of the "plugdev" group access to receiver (useful for SSH users)
      #MODE="0660", GROUP="plugdev"

      LABEL="solaar_end"
      # vim: ft=udevrules
    '';
    # Programs
    environment.systemPackages =
      with pkgs;
      [
        scrcpy
        android-tools
        solaar
        (mpv.override {
          scripts = [
            mpvScripts.mpris
            mpvScripts.sponsorblock
          ];
        })
        yt-dlp
        ispell
        nextcloud-client
        protonmail-bridge
        proton-vpn
        gparted
        anki-bin
        libreoffice
        powertop
        transmission-remote-gtk
        transmission_4-gtk
        kiwix
        koreader
        signal-desktop
        zip
        unzip
      ]
      ++ (
        if config.bzm.hardening.enable == false then
          [
            librewolf
            thunderbird
            tor-browser
          ]
        else
          [ ]
      );
    fonts.packages =
      with pkgs;
      [
        iosevka
        font-awesome
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

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
