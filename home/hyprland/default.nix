{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ../waybar ];
  # https://github.com/notohh/snowflake/blob/6009bc78f5955bfbb65a8602f5ccc9cd4b9abc8f/flake.nix
  wayland.windowManager.hyprland = let
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
    importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
      config="/home/alternateved/.config/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
      ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
      ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
      ${gsettings} set ${gnomeSchema} font-name "$font_name"
    '';
  in {
    enable = true;
    nvidiaPatches = true;
    recommendedEnvironment = true;
    extraConfig = ''
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY
      exec-once="${importGsettings}"
      exec-once=gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
      ${builtins.readFile ./hyprland.conf}
      exec-once=blueman-applet
      exec-once=nm-applet --indicator
      exec-once=kdeconnect-indicator
      exec-once=keepassxc
    '';
  };

}
