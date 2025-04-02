{
  localPort ? 0,
  url ? "rm.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    rmfakecloud = {
      enable = true;
      storageUrl = "https://${url}";
      port = localPort;
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
