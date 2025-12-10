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
    zathura.enable = true;
    alacritty.enable = true;
    zellij.enable = true;
  };
  programs.alacritty.enable = true;

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = {
      authorized_fingerprints = {
        "86:8b:df:45:bd:a5:0d:c8:83:69:0a:47:b0:09:2d:6a:5c:ea:cd:1e:4e:30:15:f0:2c:02:c2:7e:3c:03:14:a5" =
          "roshar";
        "d1:ef:61:e4:86:91:e4:bb:81:54:44:62:8d:b1:cd:56:36:32:c7:a2:ca:17:f2:d6:76:67:fc:30:71:d7:bd:84" =
          "mishim";
      };
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
