{
  localPort ? 0,
  url ? "miniflux.bezmuth.uk",
  ...
}:
{

  services = {
    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "0.0.0.0:${builtins.toString localPort}";
        FETCH_YOUTUBE_WATCH_TIME = "1";
      };
      adminCredentialsFile = "/home/bezmuth/miniflux.txt";
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        extraConfig = ''
          import tls_ts_ca
          reverse_proxy 127.0.0.1:${builtins.toString localPort}
          bind 100.64.0.3
        '';
      };
    };
  };
}
