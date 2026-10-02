{ pkgs, nixpak }:

let

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-hello = mkNixPak {
    config = { sloth, ... }: {
      app.package = pkgs.hello;
      app.binPath = "bin/hello";

      dbus.enable = true;

      dbus.policies = {
        "org.freedesktop.DBus" = "talk";
        "ca.desrt.dconf" = "talk";
      };

      flatpak.appId = "org.myself.HelloApp";

      bubblewrap = {
        network = false;

        bind.rw = [
          (sloth.concat' sloth.homeDir "/Documents")
          (sloth.env "XDG_RUNTIME_DIR")
          [
            (sloth.concat' sloth.homeDir "/.local/state/nixpak/hello/config")
            (sloth.concat' sloth.homeDir "/.config")
          ]
        ];

        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")
        ];

        bind.dev = [
          "/dev/dri"
        ];
      };
    };
  };

in
{
  hello = sandboxed-hello.config.script;
  hello-env = sandboxed-hello.config.env;
}
