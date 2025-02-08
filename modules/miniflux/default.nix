{
  config,
  localPort ? 0,
  url ? "miniflux.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}: {
  age.secrets.default-password.file = ../../secrets/default-password.age;
  services = {
    miniflux ={
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:${builtins.toString localPort}";
      };
      adminCredentialsFile = "/home/bezmuth/miniflux.txt";
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
