{
  localPort ? 0,
  url ? "navi.bezmuth.uk",
  lib,
  ...
}:
{
  systemd.services."navidrome".serviceConfig = {
    ProtectHome = lib.mkForce false;
  };
  services = {
    navidrome = {
      enable = true;
      group = "users";
      settings = {
        Port = localPort;
        Address = "0.0.0.0";
        MusicFolder = "/home/files/music/";
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
