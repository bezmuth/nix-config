{pkgs, ...}: {
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

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;
}
