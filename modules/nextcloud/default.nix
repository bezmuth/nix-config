{
  pkgs,
  config,
  localPort ? 0,
  url ? "nextcloud.bezmuth.uk",
  acmeHost ? "bezmuth.uk",
  ...
}:
{
  services = {
    nextcloud = {
      enable = true;
      configureRedis = true;
      package = pkgs.nextcloud31;
      hostName = url;
      maxUploadSize = "20G";
      config = {
        dbtype = "sqlite";
        adminpassFile = "/nextcloud.txt";
        adminuser = "bezmuth";
      };
      settings = {
        trusted_proxies = [
          "127.0.0.1"
          "100.103.106.16"
        ];
        trusted_domains = [ "nextcloud.bezmuth.uk" ];
        overwriteprotocol = "https";
        overwritehost = "nextcloud.bezmuth.uk:443";
      };
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          contacts
          bookmarks
          notes
          phonetrack
          previewgenerator
          uppush
          ;
      };
      extraAppsEnable = true;
    };
    nginx.virtualHosts."${url}".listen = [
      {
        addr = "127.0.0.1";
        port = localPort;
      }
    ];
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
          reverse_proxy 127.0.0.1:${builtins.toString localPort}
          bind 100.103.106.16
        '';
      };
    };
  };
}
