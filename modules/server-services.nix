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
    port = 10001;
    webRoot = "/shiori";
  };
  services.calibre-web = {
    enable = true;
    listen.port = 10002;
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
        proxyPass = "http://127.0.0.1:10001/";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          ''proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
            # required when the target is also TLS server with multiple hosts
            # required when the server wants to use HTTP Authentication
            proxy_pass_header Authorization;''
        ;
      };
      locations."/calibre" = {
        proxyPass = "http://127.0.0.1:10002";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          ''proxy_pass_header Authorization;
           proxy_set_header        Host            $http_host;
           proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header        X-Scheme        $scheme;
           proxy_set_header        X-Script-Name   /calibre;''  # IMPORTANT: path has NO trailing slash
        ;
      };
    };
  };
}
