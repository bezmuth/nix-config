{
  url ? "jellyfin.bezmuth.uk",
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  services = {
    jellyfin = {
      enable = true;
      user = "bezmuth";
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        extraConfig = ''
          import tls_ts_ca
          reverse_proxy http://127.0.0.1:8096
          bind 100.64.0.3
        '';
      };
    };
  };
}
