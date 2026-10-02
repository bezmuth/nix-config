{ pkgs, nixpak }:

let

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-tor-browser = mkNixPak {
    config =
      {
        config,
        sloth,
        ...
      }:
      {
        app.package = pkgs.tor-browser;
        app.binPath = "bin/tor-browser";
        flatpak.appId = "org.tor-browser.tor-browser";

        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        # https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
        dbus.policies = {
          "org.tor-browser.tor-browser.*" = "own"; # firefox
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
              (sloth.concat' sloth.homeDir "/.tor project")
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
                "${config.app.package}/lib/tor-browser"
                "/app/etc/tor-browser"
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
  tor-browser = sandboxed-tor-browser.config.script;
}
