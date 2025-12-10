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
    ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
