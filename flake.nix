{
  description = "Ben's Nixos configuration, here be dragons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    miniflux-yt-plus.url = "github:bezmuth/miniflux-yt-plus";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      systems,
      ...
    }:
    with inputs;
    let
      inherit (nixpkgs) lib;
      pc-modules = [
        ./modules/pc-services.nix
        ./modules/pc-programs.nix
        ./modules/home-manager.nix
        home-manager.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        agenix.nixosModules.default
        catppuccin.nixosModules.catppuccin
      ];

      server-modules = [
        ./modules/services.nix
        ./modules/programs.nix
        miniflux-yt-plus.nixosModules.miniflux-yt-plus
        agenix.nixosModules.default
        nix-minecraft.nixosModules.minecraft-servers
      ];
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      sharedOverlays = [
        devshell.overlays.default
        miniflux-yt-plus.overlays.default
        nur.overlays.default
        nix-minecraft.overlay
      ];

      hosts = {
        Mishim.modules = [ ./hosts/mishim ] ++ pc-modules;
        Roshar.modules = [ ./hosts/roshar ] ++ pc-modules;
        Salas.modules = [ ./hosts/salas ] ++ server-modules;
      };

      hostDefaults.modules = [ ./modules ];

      devShells.default = pkgs.devshell.mkShell {
        imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
      };
    };
}
