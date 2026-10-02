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
        ./bezmuth
      ];
      sharedModules = with inputs; [
        agenix.homeManagerModules.age
      ];
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
