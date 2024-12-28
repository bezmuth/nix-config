{...}: {
  imports = [./container.nix];
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      # other Nginx options
      virtualHosts."127.0.0.1" = {
        locations."/transmission" = {
          proxyPass = "http://127.0.0.1:9091";
          proxyWebsockets = true; # needed if you need to use WebSocket
          extraConfig =
            # required when the target is also TLS server with multiple hosts
            # required when the server wants to use HTTP Authentication
            "proxy_pass_header Authorization;";
        };
      };
    };
  };
}
