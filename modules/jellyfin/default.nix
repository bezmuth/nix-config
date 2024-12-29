{
  url ? "jellyfin.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  services = {
    jellyfin = {
      enable= true;
      user = "bezmuth";
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = acmeHost;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8096
          bind 100.103.106.16
        '';
      };
    };
  };
}
