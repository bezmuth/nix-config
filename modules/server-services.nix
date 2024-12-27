{config, ...}: {
  imports = [./services.nix ./containers/nextcloud.nix];
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
  users.users.caddy.extraGroups = ["acme"];
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
    nginx.virtualHosts."freshrss.localhost".listen = [{addr = "127.0.0.1"; port = 10003; ssl =false;}];
    gotosocial = {
      enable = true;
      settings = {
        host = "social.bezmuth.uk";
        account-domain = "bezmuth.uk";
        bind-address = "127.0.0.1";
        port = 10006;
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "bezmuth.uk".extraConfig = ''
          redir /.well-known/host-meta* https://social.bezmuth.com{uri} permanent  # host
          redir /.well-known/webfinger* https://social.bezmuth.com{uri} permanent  # host
          redir /.well-known/nodeinfo* https://social.bezmuth.com{uri} permanent   # host
          respond "Hello, world!"
        '';
        "freshrss.bezmuth.uk" = {
          useACMEHost = "bezmuth.uk";
          extraConfig = ''
            reverse_proxy http://127.0.0.1:10003
          '';
        };
        "abs.bezmuth.uk" = {
          useACMEHost = "bezmuth.uk";
          extraConfig = ''
            reverse_proxy http://127.0.0.1:10004
          '';
        };
        "calibre.bezmuth.uk" = {
          useACMEHost = "bezmuth.uk";
          extraConfig = ''
            reverse_proxy http://127.0.0.1:10002
          '';
        };
        "nextcloud.bezmuth.uk" = {
          useACMEHost = "bezmuth.uk";
          extraConfig = ''
          reverse_proxy 172.19.0.2:443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
          header {
            Strict-Transport-Security max-age=31536000;
          }
          redir /.well-known/webfinger /public.php?service=webfinger 301
          '';
        };
        "social.bezmuth.uk" = {
          useACMEHost = "bezmuth.uk";
          extraConfig = ''
            # Optional, but recommended, compress the traffic using proper protocols
            encode zstd gzip

            # The actual proxy configuration to port 8080 (unless you've chosen another port number)
            reverse_proxy * http://127.0.0.1:10006 {
              flush_interval -1
            }
          '';
        };
      };
    };
  };
}
