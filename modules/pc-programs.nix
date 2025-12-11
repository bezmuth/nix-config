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
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # enable wayland in electron apps (spotify)
      ANKI_WAYLAND = "1";
    };
    localBinInPath = true;
    systemPackages = with pkgs; [
      (catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        variant = "mocha";
      })
      mate.engrampa
      mate.eom
      tor-browser
      temurin-jre-bin-17
      prismlauncher
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
      inputs.remarkable-utility.packages.${stdenv.hostPlatform.system}.default
      r2modman
      powertop
      transmission-remote-gtk
      transmission_4-gtk
      distrobox
      boxbuddy
      ares
      dino
      cachix
      proton-pass
      anki-bin
      kiwix
      azahar
      koreader
      heroic
      dolphin-emu
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
      extraSessionCommands = "export WLR_RENDERER=vulkan PROTON_ENABLE_WAYLAND=1";
    };
    xwayland.enable = true;
    kdeconnect.enable = true;
    xfconf.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      fontPackages = [
        pkgs.corefonts
        pkgs.vista-fonts
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
