_: {
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
    packages = [
      "rocks.koreader.KOReader"
      "com.usebottles.bottles"
      "net.lutris.Lutris"
      "io.github.martinrotter.rssguard"
      "org.kde.tokodon"
    ];
  };
  environment.sessionVariables.PATH = [
    "/var/lib/flatpak/exports/share/applications/"
  ];
}
