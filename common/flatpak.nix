{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.flatpak.enable = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
  services.flatpak.packages = [
    "com.usebottles.bottles"
    "org.kde.kasts"
    "net.lutris.Lutris"
    "com.hunterwittenborn.Celeste"
    "org.prismlauncher.PrismLauncher"
  ];
}
