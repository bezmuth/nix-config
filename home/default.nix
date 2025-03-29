{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbak";
    users.bezmuth.imports = [
      ./home.nix
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
