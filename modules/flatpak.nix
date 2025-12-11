_: {
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
    packages = [
      "com.usebottles.bottles"
      "net.lutris.Lutris"
      "io.github.martinrotter.rssguard"
      "org.kde.tokodon"
      "com.github.tchx84.Flatseal"
    ];
  };
  environment.sessionVariables.PATH = [
    "/var/lib/flatpak/exports/share/applications/"
  ];
}
