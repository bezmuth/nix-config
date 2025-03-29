{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbak";
    users.bezmuth.imports = [
      ../home
    ];
    sharedModules = [
      inputs.agenix.homeManagerModules.age
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.spicetify-nix.homeManagerModules.spicetify
    ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
