{
  pkgs,
  config,
  localPort ? 0,
  url ? "nextcloud.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:   let
      tls-cert = {alt ? []}: (pkgs.runCommand "selfSignedCert" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -days 365 -nodes \
      -keyout $out/cert.key -out $out/cert.crt \
      -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,${builtins.concatStringsSep "," (["IP:127.0.0.1"] ++ alt)}"
  '');
      in
 {
  services = {
    nextcloud = {
      enable = true;
      configureRedis = true;
      package = pkgs.nextcloud30;
      hostName = url;
      maxUploadSize = "20G";
      config = {
        dbtype = "sqlite";
        adminpassFile = "/nextcloud.txt";
        adminuser = "bezmuth";
      };
      settings = {
        trusted_proxies = ["localhost" "127.0.0.1" "100.103.106.16" "nextcloud.bezmuth.uk"];
        trusted_domains = ["nextcloud.bezmuth.uk"];
        overwriteprotocol = "https";
      };
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts bookmarks notes phonetrack previewgenerator;
      };
      extraAppsEnable = true;
    };
    nginx.virtualHosts."${url}" = let
      cert = tls-cert {alt = ["IP:192.168.1.253"]};
    in {
      sslCertificate = "${cert}/cert.crt";
      sslCertificateKey = "${cert}/cert.key";
      forceSSL = true;
      listen = [
        {
          addr = "127.0.0.1";
          port = localPort;
        }
      ];
    };
    caddy = {
      enable = true;
      virtualHosts."${url}" = {
        useACMEHost = "${acmeHost}";
        extraConfig = ''
          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/webfinger /index.php/.well-known/webfinger 301
          redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301

          encode gzip
          reverse_proxy 127.0.0.1:${builtins.toString localPort} {
            transport http {
              tls_insecure_skip_verify
            }
          }
          header {
            Strict-Transport-Security max-age=31536000;
          }
          bind 100.103.106.16
        '';
      };
    };
  };
}
