# Auto-generated using compose2nix v0.3.1.
{
  pkgs,
  lib,
  ...
}: {
  # Runtime
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };

    oci-containers = {
      backend = "docker";
      containers."nextcloud" = {
        image = "lscr.io/linuxserver/nextcloud:latest";
        environment = {
          "PGID" = "100";
          "PUID" = "1000";
          "TZ" = "Etc/UTC";
        };
        volumes = [
          "/home/files/nextcloud-config:/config:rw"
          "/home/files/nextcloud-data:/data:rw"
          "/home/files/audiobooks:/audiobooks:rw"
        ];
        ports = [
          "10003:80/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--network-alias=nextcloud"
          "--network=nextcloud_default"
        ];
      };
    };
  };

  systemd = {
    services."docker-nextcloud" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [
        "docker-network-nextcloud_default.service"
      ];
      requires = [
        "docker-network-nextcloud_default.service"
      ];
      partOf = [
        "docker-compose-nextcloud-root.target"
      ];
      wantedBy = [
        "docker-compose-nextcloud-root.target"
      ];
    };
    services."docker-network-nextcloud_default" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f nextcloud_default";
      };
      script = ''
        docker network inspect nextcloud_default || docker network create nextcloud_default
      '';
      partOf = ["docker-compose-nextcloud-root.target"];
      wantedBy = ["docker-compose-nextcloud-root.target"];
    };
    targets."docker-compose-nextcloud-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
