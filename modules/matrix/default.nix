{
  localPort ? 0,
  url ? "matrix.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    mautrix-meta.instances = {
      instagram = {
        enable = true;
        registerToSynapse = true;
        settings = {
          homeserver.domain = acmeHost;
          homeserver.address = "http://localhost:${builtins.toString localPort}";
          bridge.permissions = {
            "@bezmuth:bezmuth.uk" = "admin";
          };
        };
      };
    };
    mautrix-whatsapp = {
      enable = true;
      registerToSynapse = true;
      settings = {
        homeserver.domain = acmeHost;
        homeserver.address = "http://localhost:${builtins.toString localPort}";
        bridge = {
          history_sync.request_full_sync = true;
          permissions = {
            "@bezmuth:bezmuth.uk" = "admin";
          };
        };
      };
    };
    mautrix-signal = {
      enable = true;
      registerToSynapse = true;
      settings = {
        homeserver.domain = acmeHost;
        homeserver.address = "http://localhost:${builtins.toString localPort}";
        bridge = {
          permissions = {
            "@bezmuth:bezmuth.uk" = "admin";
          };
        };
      };
    };
    postgresql.enable = true;
    matrix-synapse = {
      enable = true;
      settings.server_name = "bezmuth.uk";
      # The public base URL value must match the `base_url` value set in `clientConfig` above.
      # The default value here is based on `server_name`, so if your `server_name` is different
      # from the value of `fqdn` above, you will likely run into some mismatched domain names
      # in client applications.
      settings.public_baseurl = "https://matrix.bezmuth.uk";
      settings.listeners = [
        {
          port = localPort;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = acmeHost;
        extraConfig = ''
          reverse_proxy /_matrix/* 127.0.0.1:${builtins.toString localPort}
          bind 100.103.106.16
        '';
      };
    };
  };
}
