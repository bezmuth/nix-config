{
  localPort ? 0,
  url ? "actual.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}: {
  services = {
    actual = {
      enable = true;
      settings.port = localPort;
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
