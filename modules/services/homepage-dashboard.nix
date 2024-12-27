{
  config,
  lib,
  pkgs,
  ...
}: let
  port = 10005;
in {
  services.ngins.virtualHosts."127.0.0.1".locations."/homepage-dashboard" = {
    proxyPass = "http://127.0.0.1:${port}";
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = port;
    settings = {
      startUrl = "http://salas/homepage-dashboard";
      base = "http://salas/homepage-dashboard";
    };
  };
}
