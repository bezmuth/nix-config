{
  localPort ? 0,
  url ? "actual.bezmuth.uk",
  ...
}:
{
  services = {
    actual = {
      enable = true;
      settings.port = localPort;
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        extraConfig = ''
          import tls_ts_ca
          reverse_proxy http://127.0.0.1:${builtins.toString localPort}
          bind 100.64.0.3
        '';
      };
    };
  };
}
