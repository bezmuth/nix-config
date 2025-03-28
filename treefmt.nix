_: {
  projectRootFile = "treefmt.nix";
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
  ];

  programs.deadnix.enable = true;
  programs.nixfmt.enable = true;
}
