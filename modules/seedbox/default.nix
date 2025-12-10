{ ... }:
{
  imports = [ ./container.nix ];
  services = {
    caddy = {
      enable = true;
      virtualHosts."transmission.bezmuth.uk" = {
        extraConfig = ''
          import tls_ts_ca
          reverse_proxy http://127.0.0.1:9091
          bind 100.64.0.3
        '';
      };
    };
  };
}
