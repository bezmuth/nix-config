{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    agenix.url = "github:ryantm/agenix";
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    devshell.url = github:numtide/devshell;
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "utils";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, utils, devshell, agenix, ...}:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      shell = pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
      };
      desktopModules = [./common.nix
                        home-manager.nixosModules.home-manager
                        {
                          home-manager.useGlobalPkgs = true;
                          home-manager.useUserPackages = true;
                          home-manager.users.bezmuth.imports = [ inputs.nix-doom-emacs.hmModule ./home/home.nix ]; # i have no fucking clue why this works
                        }
                       ];
    in
    utils.lib.mkFlake{
      inherit self inputs;
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      sharedOverlays = [
        devshell.overlay
      ];

      hosts.Mishim.modules = [./machines/mishim] ++ desktopModules;
      hosts.Roshar.modules = [./machines/roshar] ++ desktopModules;
      hosts.Salas.modules  = [./machines/salas];
      hosts.Salas.system = "aarch64-linux";

      hostDefaults.modules = [
        agenix.nixosModule
      ];

      outputsBuilder = channels: with channels.nixpkgs;{
        defaultPackage = shell;

        devShell = shell;
      };


    };
}
