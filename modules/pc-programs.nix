{pkgs, ...}: {
  imports = [
    ./programs.nix
    ./flatpak.nix
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
    light.enable = true;
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
    temurin-jre-bin-17
    prismlauncher
    heroic
    qbittorrent
    cava
    playerctl
    adwaita-icon-theme
    mpv
    ispell
    veracrypt
    xdg-utils # for openning default programms when clicking links
    pulseaudio
    nextcloud-client
    jetbrains.idea-community
    jellyfin-media-player
    webcord-vencord
    thunderbird
    protonmail-bridge-gui
    android-studio
    nur.repos.shadowrz.klassy-qt6
  ];
  fonts.packages = with pkgs; [
    iosevka
    font-awesome
    emacs-all-the-icons-fonts
  ];
}
