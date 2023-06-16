{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    #devshell.inputs.flake-utils.follows = "utils";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nur.url = "github:nix-community/NUR";

    emacs-overlay.url =
      "github:nix-community/emacs-overlay/c16be6de78ea878aedd0292aa5d4a1ee0a5da501"; # pinned for now, see: https://github.com/nix-community/nix-doom-emacs/issues/409

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url =
      "github:hyprwm/Hyprland/bca3068db224d76b2da3f792efe4d0cb8cd2fe3e"; # pinned for now, weird behaviour on roshar
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, utils
    , devshell, nur, emacs-overlay, spicetify-nix, hyprland, ... }:
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
      ];

    in utils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      sharedOverlays =
        [ devshell.overlays.default (import ./pkgs) emacs-overlay.overlay ];

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
