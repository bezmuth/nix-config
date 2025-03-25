{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./programs.nix
    ./flatpak.nix
    ./librewolf
  ];
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    xwayland.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      fontPackages = [
        pkgs.corefonts
        pkgs.vistafonts
      ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    dconf.enable = true;
    gamemode.enable = true;
    gamemode.enableRenice = true;
    virt-manager.enable = true;
  };
  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
      accents = ["pink"];
      size = "compact";
      variant = "mocha";
    })
    file-roller
    tor-browser
    temurin-jre-bin-17
    prismlauncher
    heroic
    mpv
    ispell
    nextcloud-client
    webcord-vencord
    thunderbird
    protonmail-bridge
    android-studio
    proton-pass
    bleachbit
    protonvpn-gui
    gparted
    anki-bin
    libreoffice-fresh
    inputs.remarkable-utility.packages.${system}.default
    r2modman
    spotify
    htop
    powertop
  ];
  fonts.packages = with pkgs;
    [
      iosevka
      font-awesome
      emacs-all-the-icons-fonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  catppuccin.flavor = "mocha";
}
