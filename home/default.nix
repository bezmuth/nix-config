{
  inputs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.bzm.desktop.enable {
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
        nix-doom-emacs-unstraightened.homeModule
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
