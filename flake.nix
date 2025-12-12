{
  # Ben's Nixos configuration, here be dragons;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    agenix.url = "github:ryantm/agenix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    catppuccin.url = "github:catppuccin/nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = (import ./config/nixpkgs.nix) { inherit system inputs; };
      host =
        extraModules:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [ ./modules ] ++ extraModules;
          specialArgs = { inherit inputs; };
        };
    in
    {
      formatter.${system} =
        (inputs.treefmt-nix.lib.evalModule pkgs ./config/treefmt.nix).config.build.wrapper;

      nixosConfigurations = {
        Mishim = host [
          ./hosts/mishim
        ];
        Roshar = host [
          ./hosts/roshar
        ];
        Salas = host [
          ./hosts/salas
          inputs.nix-minecraft.nixosModules.minecraft-servers
        ];
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
      };

    };
}
