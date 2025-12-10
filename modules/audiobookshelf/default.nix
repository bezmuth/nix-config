{
  localPort ? 0,
  url ? "abs.bezmuth.uk",
  ...
}:
{
  services = {
    audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = localPort;
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        extraConfig = ''
          import tls_ts_ca
          encode gzip zstd
          reverse_proxy http://127.0.0.1:${builtins.toString localPort}
          bind 100.64.0.3
        '';
      };
    };
  };
}
