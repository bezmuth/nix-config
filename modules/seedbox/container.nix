# Auto-generated using compose2nix v0.3.2-pre.
{
  pkgs,
  lib,
  config,
  ...
}:
{
  age.secrets.openvpn-env.file = ../../secrets/openvpn-env.age;
  # Runtime
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers = {
      backend = "docker";
      containers."TransmissionVPN" = {
        image = "haugene/transmission-openvpn";
        environmentFiles = [
          config.age.secrets.openvpn-env.path
        ];

        volumes = [
          # need to place an openvpn config file here named ch.protonvpn.udp.ovpn
          "/home/bezmuth/nix-config/modules/seedbox/vpnconfig:/etc/openvpn/custom/:rw"
          "/home/files:/data:rw"
          "seedbox-config:/config:rw"
        ];
        ports = [
          "9091:9091/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=mknod"
          "--device=/dev/net/tun:/dev/net/tun:rwm"
          "--network-alias=transmission-openvpn"
          "--network=seedbox_default"
        ];
      };
    };
  };
  systemd = {
    services = {
      "docker-TransmissionVPN" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "on-failure";
        };
        startLimitBurst = 2;
        unitConfig = {
          StartLimitIntervalSec = lib.mkOverride 90 "infinity";
        };
        after = [
          "docker-network-seedbox_default.service"
        ];
        requires = [
          "docker-network-seedbox_default.service"
        ];
        partOf = [
          "docker-compose-seedbox-root.target"
        ];
        wantedBy = [
          "docker-compose-seedbox-root.target"
        ];
      };
      "docker-seedbox-app" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartMaxDelaySec = lib.mkOverride 90 "1m";
          RestartSec = lib.mkOverride 90 "100ms";
          RestartSteps = lib.mkOverride 90 9;
        };
        after = [
          "docker-network-seedbox_default.service"
        ];
        requires = [
          "docker-network-seedbox_default.service"
        ];
        partOf = [
          "docker-compose-seedbox-root.target"
        ];
        wantedBy = [
          "docker-compose-seedbox-root.target"
        ];
      };
      "docker-network-seedbox_default" = {
        path = [ pkgs.docker ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "docker network rm -f seedbox_default";
        };
        script = ''
          docker network inspect seedbox_default || docker network create seedbox_default
        '';
        partOf = [ "docker-compose-seedbox-root.target" ];
        wantedBy = [ "docker-compose-seedbox-root.target" ];
      };
    };
    targets."docker-compose-seedbox-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
