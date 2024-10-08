{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # for sway latest (nvidia explicit sync)
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    remarkable-utility.url = "github:404Wolf/remarkable-connection-utility";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      utils,
      devshell,
      hyprland,
      spicetify-nix,
      emacs-overlay,
      nix-flatpak,
      nixpkgs-wayland,
      remarkable-utility,
      ...
    }:
    let
      desktopModules = [
        nix-flatpak.nixosModules.nix-flatpak
        ./common
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbak";
          home-manager.users.bezmuth.imports = [
            inputs.spicetify-nix.homeManagerModules.default
            inputs.hyprland.homeManagerModules.default
            ./home
          ];
          home-manager.extraSpecialArgs = {
            inherit inputs self;
          };
        }
      ];

    in
    utils.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      channelsConfig.allowUnfree = true;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      sharedOverlays = [
        inputs.nixpkgs-wayland.overlay
        devshell.overlays.default
        emacs-overlay.overlay
        (import ./pkgs)
      ];

      hosts.Mishim.modules = [ ./machines/mishim ] ++ desktopModules;
      hosts.Roshar.modules = [ ./machines/roshar ] ++ desktopModules;
      hosts.Salas.modules = [ ./machines/salas ];
      hosts.Salas.system = "aarch64-linux";

      hostDefaults.modules = [ ];

      outputsBuilder =
        channels: with channels.nixpkgs; {
          defaultPackage = channels.nixpkgs.devshell.mkShell {
            imports = [ (channels.nixpkgs.devshell.importTOML ./devshell.toml) ];
          };
          devShell = channels.nixpkgs.devshell.mkShell {
            imports = [ (channels.nixpkgs.devshell.importTOML ./devshell.toml) ];
          };
        };
    };
}
