{
  localPort ? 0,
  url ? "calibre.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}: {
  services = {
    calibre-web = {
      group = "srv-data";
      enable = true;
      listen = {
        ip = "127.0.0.1";
        port = localPort;
      };
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
      };
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
