{ pkgs, nixpak }:

let

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-thunderbird = mkNixPak {
    config =
      {
        config,
        sloth,
        ...
      }:
      {
        app.package = pkgs.thunderbird;
        app.binPath = "bin/thunderbird";
        flatpak.appId = "org.thunderbird.thunderbird";

        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        # https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
        dbus.policies = {
          "org.thunderbird.thunderbird.*" = "own"; # firefox
          # "org.mozilla.firefox_beta.*" = "own"; # firefox beta (?)
          # "io.gitlab.librewolf.*" = "own";      # librewolf
        };

        bubblewrap =
          let
            envSuffix = envKey: sloth.concat' (sloth.env envKey);
          in
          {
            bind.rw = [
              "xdg-download"
              (sloth.concat' sloth.homeDir "/.thunderbird")
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
                "${config.app.package}/lib/thunderbird"
                "/app/etc/thunderbird"
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
  thunderbird = sandboxed-thunderbird.config.script;
}
