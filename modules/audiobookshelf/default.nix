{
  localPort ? 0,
  url ? "abs.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}: {
  services = {
    audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = localPort;
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = acmeHost;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${builtins.toString localPort}
          bind 100.103.106.16
        '';
      };
    };
  };
}
