{...}: {
  imports = [./container.nix];
  services = {
    caddy = {
      enable = true;
      virtualHosts."transmission.bezmuth.uk" = {
        useACMEHost = "bezmuth.uk";
        extraConfig = ''
          reverse_proxy http://127.0.0.1:9091
        '';
      };
    };
  };
}
