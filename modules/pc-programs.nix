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
    (papirus-icon-theme.override {color = "pink";})
    (catppuccin-gtk.override {
      accents = ["pink"];
      size = "compact";
      variant = "mocha";
    })
    tor-browser
    temurin-jre-bin-17
    prismlauncher
    heroic
    mpv
    ispell
    nextcloud-client
    #jetbrains.idea-community
    webcord-vencord
    thunderbird
    protonmail-bridge-gui
    android-studio
    nur.repos.shadowrz.klassy-qt6
    proton-pass
    bleachbit
    protonvpn-gui
    gparted
    anki-bin
    libreoffice-fresh
    inputs.remarkable-utility.packages.${system}.default
    r2modman
    spotify
  ];
  fonts.packages = with pkgs; [
    iosevka
    font-awesome
    emacs-all-the-icons-fonts
  ];
}
