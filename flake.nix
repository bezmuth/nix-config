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
    remarkable-utility.url = "github:404Wolf/remarkable-connection-utility";
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
    with inputs;
    let
      system = "x86_64-linux";
      pkgs = (import ./config/nixpkgs.nix) { inherit system inputs; };
      common-modules = [
        ./modules
        agenix.nixosModules.default
      ];
      pc-modules = [
        ./modules/pc-services.nix
        ./modules/pc-programs.nix
        ./home
        home-manager.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        catppuccin.nixosModules.catppuccin
      ];
      server-modules = [
        nix-minecraft.nixosModules.minecraft-servers
      ];
      host =
        modules:
        nixpkgs.lib.nixosSystem {
          inherit pkgs modules;
          specialArgs = { inherit inputs; };
        };
    in
    {
      formatter.${system} = (treefmt-nix.lib.evalModule pkgs ./config/treefmt.nix).config.build.wrapper;

      nixosConfigurations = {
        Mishim = host ([ ./hosts/mishim ] ++ pc-modules ++ common-modules);
        Roshar = host ([ ./hosts/roshar ] ++ pc-modules ++ common-modules);
        Salas = host ([ ./hosts/salas ] ++ server-modules ++ common-modules);
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
      };

    };
}
