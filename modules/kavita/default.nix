{
  localPort ? 0,
  url ? "kavita.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    kavita = {
      group = "srv-data";
      enable = true;
      settings = {
        Port = localPort;
      };
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
