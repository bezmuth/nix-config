{
  url ? "jellyfin.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  pkgs,
  ...
}: {
  services = {
    jellyfin = {
      enableA= true;
      group = "srv-data";
      dataDir = "/home/files/jellyfin";
    };
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
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
