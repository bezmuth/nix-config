{
  localPort ? 0,
  url ? "calibre.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
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
          reverse_proxy 127.0.0.1:${builtins.toString localPort} {
              header_up X-Scheme https
          }
        '';
      };
    };
  };
}
