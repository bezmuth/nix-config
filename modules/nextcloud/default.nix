{
  url ? "nextcloud.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}: {
  imports = [./container.nix];
  services.caddy = {
    enable = true;
    virtualHosts."${url}" = {
      useACMEHost = "${acmeHost}";
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
        bind 100.103.106.16
      '';
    };
  };
}
