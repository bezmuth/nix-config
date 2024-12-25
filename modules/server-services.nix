{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./services.nix];
  services.openssh.enable = true;
  age.identityPaths = ["/home/bezmuth/.ssh/id_ed25519"];
  users.groups.srv-data = {};
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.calibre-web = {
    group = "srv-data";
    enable = true;
    listen = {
      ip = "127.0.0.1";
      port = 10002;
    };
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };
  # reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    # other Nginx options
    virtualHosts."127.0.0.1" = {
      locations."/transmission" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;";
      };
      locations."/calibre" = {
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig = ''
          proxy_bind           $server_addr;
          proxy_pass           http://127.0.0.1:10002;
          proxy_set_header     Host $host;
          proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header     X-Scheme        $scheme;
          proxy_set_header     X-Script-Name   /calibre;  # IMPORTANT: path has NO trailing slash
          client_max_body_size 1024M;
        '';
      };
      locations."/nextcloud/" = {
        extraConfig = ''
          proxy_pass http://localhost:10003/; # set this to the nextcloud port set in doccker-compose file
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          client_max_body_size 0;
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";

          access_log /var/log/nginx/nextcloud.access.log;
          error_log /var/log/nginx/nextcloud.error.log;
        '';
      };
      locations."/nextcloud/.well-known/carddav" = {
        extraConfig = ''
          return 301 $scheme://$host/remote.php/dav;
        '';
      };
      locations."/nextcloud/.well-known/caldav" = {
        extraConfig = ''
          return 301 $scheme://$host/remote.php/dav;
        '';
      };
    };
  };
}
