{
  config,
  localPort ? 0,
  url ? "miniflux.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  age.secrets.miniflux-token = {
    file = ../../secrets/miniflux-token.age;
    owner = "miniflux-yt-plus";
  };
  services = {
    miniflux-yt-plus = {
      enable = true;
      miniflux-url = "http://localhost:${builtins.toString localPort}/";
      tokenfile-path = config.age.secrets.miniflux-token.path;
      remove-livestreams = true;
    };
    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:${builtins.toString localPort}";
        FETCH_YOUTUBE_WATCH_TIME = "1";
      };
      adminCredentialsFile = "/home/bezmuth/miniflux.txt";
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = acmeHost;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${builtins.toString localPort}
        '';
      };
    };
  };
}
