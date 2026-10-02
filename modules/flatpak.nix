{ config, lib, ... }:
{
  config = lib.mkIf config.bzm.desktop.enable {
    services.flatpak = {
      enable = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
      packages = [
        "com.usebottles.bottles"
        "net.lutris.Lutris"
        "com.github.tchx84.Flatseal"
        "io.github.ungoogled_software.ungoogled_chromium"
        "io.gitlab.librewolf-community"
      ];
    };
    environment.sessionVariables.PATH = [
      "/var/lib/flatpak/exports/share/applications/"
    ];
  };
}
