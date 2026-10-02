{
  lib,
  localPort ? 0,
  url ? "calibre.bezmuth.uk",
  ...
}:
{
  systemd.services.calibre-web.serviceConfig = {
    ProtectHome = lib.mkForce false;
  };
  services = {
    calibre-web = {
      #package = pkgs.calibre-web.overridePythonAttrs {
      #  pythonRelaxDeps = [
      #    "wand"
      #    "regex"
      #    "flask-babel"
      #    "pypdf"
      #    "lxml"
      #    "requests"
      #  ];
      #};
      group = "srv-data";
      enable = true;
      listen = {
        ip = "0.0.0.0";
        port = localPort;
      };
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
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
