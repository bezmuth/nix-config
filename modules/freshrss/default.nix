{
  config,
  localPort ? 0,
  url ? "freshrss.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  age.secrets.default-password.file = ../../secrets/default-password.age;
  services = {
    freshrss = {
      enable = true;
      virtualHost = "freshrss.localhost";
      defaultUser = "bezmuth";
      passwordFile = "${config.age.secrets.default-password.path}";
      baseUrl = "https://${url}";
    };
    nginx.virtualHosts."freshrss.localhost".listen = [
      {
        addr = "127.0.0.1";
        port = localPort;
        ssl = false;
      }
    ];
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
