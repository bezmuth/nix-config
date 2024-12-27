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
        "calibre.bezmuth.uk" = {
          serverName = "calibre.bezmuth.uk";
          forceSSL = true;
          useACMEHost = "bezmuth.uk";
          locations = {
            "/" = {
              proxyWebsockets = true;
              extraConfig = ''
                proxy_pass http://127.0.0.1:10002;
              '';
            };
          };
        };
      };
    };
  };
}
