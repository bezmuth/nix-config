{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./services.nix];
  services.openssh.enable = true;
  age.identityPaths = [ "/home/bezmuth/.ssh/id_ed25519" ];
    networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    # other Nginx options
    virtualHosts."salas" =  {
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;"
          ;
      };
    };
};
}
