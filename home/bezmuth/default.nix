{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "bezmuth";
    homeDirectory = "/home/bezmuth";
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      grc
    ];
  };

  age = {
    secrets = {
      miniflux-emacs-token = {
        file = ../../secrets/miniflux-emacs-token.age;
      };
    };
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  };

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "pink"; };
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "pink";
    swaylock.enable = true;
    thunderbird.enable = true;
    gtk.enable = true;
    zathura.enable = true;
    alacritty.enable = true;
    zellij.enable = true;
  };
  programs.alacritty.enable = true;

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = {
      clients = [
        {
          position = if osConfig.networking.hostName == "Roshar" then "bottom" else "top";
          hostname = if osConfig.networking.hostName == "Roshar" then "mishim" else "roshar";
          activate_on_startup = true;
        }
      ];
    };
  };
}
