{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./flatpak.nix
    ./librewolf
  ];
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1"; # enable wayland in electron apps (spotify)
    localBinInPath = true;
    systemPackages = with pkgs; [
      (catppuccin-gtk.override {
        accents = [ "pink" ];
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
      powertop
      transmission-remote-gtk
      wdisplays
      transmission_4-gtk
      distrobox
      boxbuddy
      ares
      unciv
      endless-sky
      openttd
      dino
    ];
  };
  programs = {
    # both the fish and bash bits are needed for fish to work
    fish.enable = true;
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = "export WLR_RENDERER=vulkan";
    };
    xwayland.enable = true;
    kdeconnect.enable = true;
    xfconf.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
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
  fonts.packages =
    with pkgs;
    [
      iosevka
      font-awesome
      emacs-all-the-icons-fonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  catppuccin = {
    flavor = "mocha";
    accent = "pink";
    tty.enable = true;
  };
}
