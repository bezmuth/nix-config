{config, ...}: {
  imports = [./services.nix];
  age.identityPaths = ["/home/bezmuth/.ssh/id_ed25519"];
  users.groups.srv-data = {};
  age.secrets.default-password.file = ../secrets/default-password.age;
  age.secrets.cloudflare-token.file = ../secrets/cloudflare-token.age;
  age.secrets.dns-token.file = ../secrets/dns-token.age;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "benkel97@protonmail.com";
    certs."bezmuth.uk" = {
      domain = "bezmuth.uk";
      extraDomainNames = ["*.bezmuth.uk"];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialFiles = {"CF_DNS_API_TOKEN_FILE" = config.age.secrets.dns-token.path;};
    };
  };
  users.users.nginx.extraGroups = ["acme"];
  services = {
    openssh.enable = true;
    cloudflare-dyndns = {
      enable = true;
      domains = [
        "bezmuth.uk"
      ];
      apiTokenFile = config.age.secrets.cloudflare-token.path;
    };
    calibre-web = {
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
    audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = 10004;
    };
    freshrss = {
      enable = true;
      virtualHost = "freshrss.localhost";
      defaultUser = "bezmuth";
      passwordFile = "${config.age.secrets.default-password.path}";
      baseUrl = "https://freshrss.bezmuth.uk";
    };

    seafile = {
      enable = true;
      group = "srv-data";

      adminEmail = "benkel97@protonmail.com";
      initialAdminPassword = "123456";

      ccnetSettings.General.SERVICE_URL = "https://seafile.bezmuth.uk";

      seafileSettings = {
        quota.default = "50"; # Amount of GB allotted to users
        history.keep_days = "14"; # Remove deleted files after 14 days

        fileserver = {
          host = "unix:/run/seafile/server.sock";
        };
      };
      gc = {
        enable = true;
        dates = ["Sun 03:00:00"];
      };
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "bezmuth.uk" = {
          serverName = "bezmuth.uk";
          useACMEHost = "bezmuth.uk";
          forceSSL = true;
          locations."/" = {
            #root = "/var/www";
          };
        };

        "freshrss.bezmuth.uk" = {
          serverName = "freshrss.bezmuth.uk";
          forceSSL = true;
          useACMEHost = "bezmuth.uk";
          locations = {
            "/" = {
              extraConfig = ''
                proxy_pass http://freshrss.localhost;
                proxy_buffering off;
                proxy_set_header X-Forwarded-Port $server_port;
                proxy_cookie_path / "/; HTTPOnly; Secure";
                proxy_set_header Authorization $http_authorization;
                proxy_pass_header Authorization;
              '';
            };
          };
        };

        "seafile.bezmuth.uk" = {
          forceSSL = true;
          useACMEHost = "bezmuth.uk";
          locations = {
            "/" = {
              proxyPass = "http://unix:/run/seahub/gunicorn.sock";
              extraConfig = ''
                proxy_set_header   Host $host;
                proxy_set_header   X-Real-IP $remote_addr;
                proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header   X-Forwarded-Host $server_name;
                proxy_read_timeout  1200s;
                client_max_body_size 0;
              '';
            };
            "/seafhttp" = {
              proxyPass = "http://unix:/run/seafile/server.sock";
              extraConfig = ''
                rewrite ^/seafhttp(.*)$ $1 break;
                client_max_body_size 0;
                proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_connect_timeout  36000s;
                proxy_read_timeout  36000s;
                proxy_send_timeout  36000s;
                send_timeout  36000s;
              '';
            };
            "/seafdav" = {
              extraConfig = ''
                proxy_pass         http://127.0.0.1:8080;
                proxy_set_header   Host $host;
                proxy_set_header   X-Real-IP $remote_addr;
                proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header   X-Forwarded-Host $server_name;
                proxy_set_header   X-Forwarded-Proto https;
                proxy_http_version 1.1;
                proxy_connect_timeout  36000s;
                proxy_read_timeout  36000s;
                proxy_send_timeout  36000s;
                send_timeout  36000s;

                # This option is only available for Nginx >= 1.8.0. See more details below.
                client_max_body_size 0;
                proxy_request_buffering off;

                access_log      /var/log/nginx/seafdav.access.log;
                error_log       /var/log/nginx/seafdav.error.log;
              '';
            };
          };
        };

        "abs.bezmuth.uk" = {
          serverName = "abs.bezmuth.uk";
          forceSSL = true;
          useACMEHost = "bezmuth.uk";
          locations = {
            "/" = {
              proxyWebsockets = true;
              extraConfig = ''
                proxy_pass http://127.0.0.1:10004;
              '';
            };
          };
        };
      };
    };
  };
}
