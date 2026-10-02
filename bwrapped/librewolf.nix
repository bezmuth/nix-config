{ pkgs, nixpak }:

let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-librewolf = mkNixPak {
    config =
      {
        config,
        sloth,
        ...
      }:
      {
        app.package = pkgs.librewolf;
        app.binPath = "bin/librewolf";
        flatpak.appId = "org.librewolf.librewolf";

        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        # https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
        dbus.policies = {
          "org.freedesktop.FileManager1" = "talk";
          "org.gtk.vfs.*" = "talk";
          "org.librewolf.librewolf.*" = "own";
          "org.mozilla.firefox.*" = "own";
          "org.mpris.MediaPlayer2.firefox.*" = "own";
        };

        bubblewrap =
          let
            envSuffix = envKey: sloth.concat' (sloth.env envKey);
          in
          {
            bind.rw = [
              "xdg-download"
              (sloth.concat' sloth.homeDir "/.librewolf/")
              (sloth.concat' sloth.homeDir "/.config/librewolf")
              (sloth.concat' sloth.homeDir "/Downloads")

              # Unsure
              "/tmp/.X11-unix"
              (sloth.envOr "XAUTHORITY" "/no-xauth")
              (envSuffix "XDG_RUNTIME_DIR" "/dconf")
            ];
            bind.ro = [
              # To actually make Firefox run
              "/sys/bus/pci"
              [
                "${config.app.package}/lib/librewolf"
                "/app/etc/librewolf"
              ]

              # Use correct timezone
              "/etc/localtime"

              # Unsure
              (sloth.concat' sloth.xdgConfigHome "/dconf")
            ];
          };
      };
  };

in
{
  librewolf = sandboxed-librewolf.config.script;
}
