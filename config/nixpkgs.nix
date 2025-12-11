{ system, inputs, ... }:

import inputs.nixpkgs {
  inherit system;
  config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    # GPU decode/encode for salas
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };
  overlays = [
    inputs.devshell.overlays.default
    inputs.nix-minecraft.overlay
    (import ../pkgs)
  ];
}
