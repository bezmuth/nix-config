_: {
  settings.global.excludes = [
    "*.toml"
    "*.age"
    "*.png"
    "*.sh"
    "*."
    "*.el"
    "*.md"
    "LICENSE"
    ".envrc"
    "hardware-configuration.nix"
    "container.nix"
  ];

  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt.enable = true;
  };
}
