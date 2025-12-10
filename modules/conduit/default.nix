{
  server_name ? "matrix.bezmuth.uk",
  localPort ? 0,
  ...
}:
{
  services = {
    mautrix-meta.instances = {
      instagram = {
        enable = true;
        settings = {
          homeserver.domain = server_name;
          homeserver.address = "http://matrix.bezmuth.uk";
          bridge.permissions = {
            "@bezmuth:matrix.bezmuth.uk" = "admin";
          };
        };
      };
    };
    mautrix-whatsapp = {
      enable = true;
      settings = {
        homeserver.domain = server_name;
        homeserver.address = "https://matrix.bezmuth.uk";
        bridge = {
          history_sync.request_full_sync = true;
          permissions = {
            "@bezmuth:matrix.bezmuth.uk" = "admin";
          };
        };
      };
    };
    mautrix-signal = {
      enable = true;
      settings = {
        homeserver.domain = server_name;
        homeserver.address = "https://matrix.bezmuth.uk";
        bridge = {
          permissions = {
            "@bezmuth:matrix.bezmuth.uk" = "admin";
          };
        };
      };
    };
    mautrix-discord = {
      enable = false;
      settings = {
        homeserver.domain = server_name;
        homeserver.address = "https://matrix.bezmuth.uk";
        bridge = {
          history_sync.request_full_sync = true;
          permissions = {
            "@bezmuth:matrix.bezmuth.uk" = "admin";
          };
        };
      };
    };
    matrix-conduit = {
      enable = true;
      settings.global = {
        inherit server_name;
        address = "100.64.0.3";
        port = localPort;
        allow_registration = false;
        allow_federation = false;
        well_known.server = "matrix.bezmuth.uk:443";
        well_known.client = "https://matrix.bezmuth.uk";
      };
    };
  };
}
