{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbak";
    users.bezmuth.imports = [
      ./home.nix
    ];
    sharedModules = with inputs; [
      agenix.homeManagerModules.age
      catppuccin.homeModules.catppuccin
      spicetify-nix.homeManagerModules.spicetify
      lan-mouse.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
