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
      "com.hunterwittenborn.Celeste"
      "org.prismlauncher.PrismLauncher"
      "io.github.martinrotter.rssguard"
    ];
  };
  environment.sessionVariables.PATH = [
    "/var/lib/flatpak/exports/share/applications/"
  ];
}
