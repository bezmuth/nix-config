{
  localPort ? 0,
  url ? "ntfy.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${builtins.toString url}";
        listen-http = ":${builtins.toString localPort}";
      };
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = acmeHost;
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString localPort}
          bind 100.103.106.16
        '';
      };
    };
  };
}
