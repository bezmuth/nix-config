{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    devshell.url = "github:numtide/devshell";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    remarkable-utility.url = "github:404Wolf/remarkable-connection-utility";
    # doom emacs install repo
    doom-emacs-src = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    lan-mouse.url = "github:feschber/lan-mouse";
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    with inputs;
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "olm-3.2.16"
        ];

        # GPU decode/encode for salas
        config.packageOverrides = pkgs: {
          vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
        };
        overlays = [
          devshell.overlays.default
          nix-minecraft.overlay
          (import ./pkgs)
        ];
      };
      pkgs-master = import nixpkgs-master { inherit system; };
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
      ]
      ++ common-modules;
      server-modules = [
        nix-minecraft.nixosModules.minecraft-servers
      ]
      ++ common-modules;
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      host =
        modules:
        nixpkgs.lib.nixosSystem {
          inherit pkgs modules;
          specialArgs = { inherit inputs pkgs-master; };
        };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      nixosConfigurations = {
        Mishim = host ([ ./hosts/mishim ] ++ pc-modules);
        Roshar = host ([ ./hosts/roshar ] ++ pc-modules);
        Salas = host ([ ./hosts/salas ] ++ server-modules);
      };

      devShells.${system}.default = pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
      };

    };
}
