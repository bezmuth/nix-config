{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    pc-modules =
      [
        ./modules
        ./modules/pc-services.nix
        ./modules/pc-programs.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hmbak";
            users.bezmuth.imports = [
              ./home
            ];
            extraSpecialArgs = {
              inherit inputs self;
            };
          };
        }
      ]
      ++ (with inputs; [
        home-manager.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        agenix.nixosModules.default
      ]);
    server-modules =
      [
        ./modules
        ./modules/server-services.nix
        ./modules/server-programs.nix
        ./modules/containers/seedbox.nix
      ]
      ++ (with inputs; [
        inputs.agenix.nixosModules.default
      ]);
  in
    inputs.utils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [
        "x86_64-linux"
      ];
      channelsConfig.allowUnfree = true;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      sharedOverlays = [
        inputs.devshell.overlays.default
        (import ./pkgs)
      ];

      hosts.Mishim.modules = [./hosts/mishim] ++ pc-modules;
      hosts.Roshar.modules = [./hosts/roshar] ++ pc-modules;
      hosts.Salas.modules = [./hosts/salas] ++ server-modules;

      hostDefaults.modules = [];

      outputsBuilder = channels:
        with channels.nixpkgs; {
          defaultPackage = channels.nixpkgs.devshell.mkShell {
            imports = [(channels.nixpkgs.devshell.importTOML ./devshell.toml)];
          };
          devShell = channels.nixpkgs.devshell.mkShell {
            imports = [(channels.nixpkgs.devshell.importTOML ./devshell.toml)];
          };
        };
    };
}
