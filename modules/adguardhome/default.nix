{
  localPort ? 0,
  url ? "dns.bezmuth.uk",
  ...
}:
{
  services = {
    adguardhome = {
      enable = true;
      # You can select any ip and port, just make sure to open firewalls where needed
      host = "127.0.0.1";
      port = localPort;
      mutableSettings = true;
      settings = {
        dns = {
          upstream_dns = [
            # Example config with quad9
            "9.9.9.9"
            "149.112.112.112"
            # Uncomment the following to use a local DNS service (e.g. Unbound)
            # Additionally replace the address & port as needed
            # "127.0.0.1:5335"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          parental_enabled = false; # Parental control-based DNS requests filtering.
          safe_search = {
            enabled = false; # Enforcing "Safe search" option for search engines, when possible.
          };
        };
        # The following notation uses map
        # to not have to manually create {enabled = true; url = "";} for every filter
        # This is, however, fully optional
        filters =
          map
            (url: {
              enabled = true;
              inherit url;
            })
            [
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt" # hegezi ultimate
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt" # hegezi Threat Intelligence Feeds
            ];
        cache = {
          enabled = true;
          cache_size = "1073741824";
        };
      };
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        extraConfig = ''
          import tls_ts_ca
          reverse_proxy 127.0.0.1:${builtins.toString localPort}
          bind 100.64.0.3
        '';
      };
    };
  };
}
