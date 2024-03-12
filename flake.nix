{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows =
        "nixpkgs"; # override this repo's nixpkgs snapshot
    };

    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs"; };

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    #devshell.inputs.flake-utils.follows = "utils";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url =
      "github:hyprwm/Hyprland/"; # pinned for now, weird behaviour on roshar
    eww.url = "github:ralismark/eww/tray-3";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, utils
    , devshell, nur, hyprland, eww, nh, spicetify-nix, ... }:
    let
      desktopModules = [
        # This adds a nur configuration option.
        # Use `config.nur` for packages like this:
        # ({ config, ... }: {
        #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
        # })
        nur.nixosModules.nur
        ./common
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bezmuth.imports = [
            inputs.nix-doom-emacs.hmModule # i have no fucking clue why this works
            inputs.spicetify-nix.homeManagerModule
            inputs.hyprland.homeManagerModules.default
            ./home
          ];
          home-manager.extraSpecialArgs = { inherit inputs self; };
        }
        inputs.nh.nixosModules.default
        {
          nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 4d --keep 3";
          };
        }
      ];

    in utils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      sharedOverlays = [ devshell.overlays.default (import ./pkgs) ];

      hosts.Mishim.modules = [ ./machines/mishim ] ++ desktopModules;
      hosts.Roshar.modules = [ ./machines/roshar ] ++ desktopModules;
      hosts.Salas.modules = [ ./machines/salas ];
      hosts.Salas.system = "aarch64-linux";

      hostDefaults.modules = [ ];

      outputsBuilder = channels:
        with channels.nixpkgs; {
          defaultPackage = channels.nixpkgs.devshell.mkShell {
            imports =
              [ (channels.nixpkgs.devshell.importTOML ./devshell.toml) ];
          };
          devShell = channels.nixpkgs.devshell.mkShell {
            imports =
              [ (channels.nixpkgs.devshell.importTOML ./devshell.toml) ];
          };
        };
    };
}
