{
  pkgs,
  nixpak,
  inputs,
}:

let

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-agenix = mkNixPak {
    config =
      {
        sloth,
        ...
      }:
      {
        app.package = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
        app.binPath = "bin/agenix";

        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/nix-config")
            # (sloth.env "HOME")
          ];
        };
      };
  };

in
{
  agenix = sandboxed-agenix.config.script;
}
