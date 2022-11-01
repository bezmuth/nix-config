{
  description = "Bezmuth's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-doom-emacs, flake-utils, devshell, agenix, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [devshell.overlay];
      };
      baseModules = [
        agenix.nixosModule
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bezmuth =  { pkgs, ... }: {
            imports = [ nix-doom-emacs.hmModule ./home/home.nix ];
            programs.doom-emacs = {
              enable = true;
              doomPrivateDir = ./home/doom.d;
              emacsPackage = pkgs.emacsNativeComp;
            };
          };
        }
      ];
    in
    {
    devShells."${system}".default =
      pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
    };

    nixosConfigurations = {
      Mishim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = baseModules ++ [./machines/mishim ./common.nix];
      };
      Roshar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = baseModules ++ [./machines/roshar ./common.nix];
      };
      Salas = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = baseModules ++ [./machines/salas];
      };
    };
  };
}
