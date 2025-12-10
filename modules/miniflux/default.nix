{
  localPort ? 0,
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
  };
}
