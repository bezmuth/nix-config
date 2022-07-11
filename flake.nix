{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-doom-emacs, ... }: {
    nixosConfigurations = {
      Mishim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
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

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
