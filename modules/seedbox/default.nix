{...}: {
  imports = [./container.nix];
  services = {
    caddy = {
      enable = true;
      virtualHosts."127.0.0.1" = {
        extraConfig = ''
          http_port 9091
          reverse_proxy http://127.0.0.1:9091
        '';
      };
    };
  };
}
