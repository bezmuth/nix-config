{
  localPort ? 0,
  url ? "social.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    gotosocial = {
      enable = true;
      settings = {
        host = "${url}";
        bind-address = "127.0.0.1";
        port = localPort;
      };
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = "${acmeHost}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy * http://127.0.0.1:${builtins.toString localPort} {
            flush_interval -1
          }
        '';
      };
    };
  };
}
