{ config, pkgs, lib, inputs, ... }:

let
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };

in {
  wayland.windowManager.hyprland = {
    enable = true;
    #nvidiaPatches = true;
    extraConfig = ''
      exec-once=${dbus-hyprland-environment}
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY &
      exec-once=gnome-keyring-daemon --start --components=pkcs11,secrets,ssh &
      ${builtins.readFile ./hyprland.conf}
      exec-once=blueman-applet
      exec-once=nm-applet --indicator
      exec-once=kdeconnect-indicator
      exec-once=keepassxc
      exec-once=xhost +local:
    '';
  };

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    playerctl
    networkmanagerapplet
    picom
    swaylock
    libnotify
    pcmanfm
  ];

  imports = [ ../eww ../mako ../rofi ];

  #services.blueman-applet.enable = true;

  #services.network-manager-applet.enable = true;

}
