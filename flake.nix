{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, utils, devshell, nur, hyprland
    , spicetify-nix, emacs-overlay, nix-flatpak, ... }:
    let
      desktopModules = [
        nur.nixosModules.nur
        nix-flatpak.nixosModules.nix-flatpak
        ./common
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbak";
          home-manager.users.bezmuth.imports = [
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
        [ devshell.overlays.default emacs-overlay.overlay (import ./pkgs) ];

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
