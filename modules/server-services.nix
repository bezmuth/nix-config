{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./services.nix];
  services.openssh.enable = true;
  age.identityPaths = [ "/home/bezmuth/.ssh/id_ed25519" ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.shiori = {
    enable = true;
    port = 1001;
  };
  services.calibre-web = {
    enable = true;
    listen.port = 1002;
    options.enableBookUploading = true;
  };
  # reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    # other Nginx options
    virtualHosts."127.0.0.1" =  {
      locations."/transmission" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
        ;
      };
      locations."/shiori" = {
        proxyPass = "http://127.0.0.1:1001";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
        ;
      };
      locations."/calibre" = {
        proxyPass = "http://127.0.0.1:1002";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
        ;
      };
    };
  };
}
