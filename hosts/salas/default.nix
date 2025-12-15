# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
args@{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  networking = {
    hostName = "Salas";
    firewall.allowedTCPPorts = [ ];
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../../modules/seedbox args)
    #(import ../../modules/ts-exitnode args)
    (import ../../modules/jellyfin args)
    (import ../../modules/audiobookshelf (args // { localPort = 10000; }))
    (import ../../modules/calibre-web (args // { localPort = 10001; }))
    (import ../../modules/miniflux (args // { localPort = 10002; }))
    (import ../../modules/gotosocial (args // { localPort = 10003; }))
    (import ../../modules/actual (args // { localPort = 10004; }))
    (import ../../modules/nextcloud (args // { localPort = 10005; }))
    (import ../../modules/rmfakecloud (args // { localPort = 10006; }))
    (import ../../modules/conduit (args // { localPort = 10007; }))
    #(import ../../modules/ntfy (args // { localPort = 10008; }))
    (import ../../modules/navidrome (args // { localPort = 10009; }))
    #../../modules/paper
  ];

  virtualisation.podman.enable = true;

  services.snowflake-proxy = {
    enable = true;
    capacity = 100;
  };

  # load caddy after tailscale so it doesn't cry all the time
  systemd.services.caddy.serviceConfig = {
    After = [ "tailscaled.service" ];
    Restart = lib.mkOverride 0 "on-failure";
    RestartSec = lib.mkOverride 0 "20s";
    StartLimitBurst = lib.mkOverride 0 "5";
    StartLimitIntervalSec = lib.mkOverride 0 "60";
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  age = {
    identityPaths = [ "/home/bezmuth/.ssh/id_ed25519" ];
  };

  users = {
    groups.srv-data = { };
    users = {
      caddy.extraGroups = [ "acme" ];
      "bezmuth".openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6zoHZ2w6Mo6KOiubft6bjHhOZTCnzRJm2Yp2Xk8YPv"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5g+dx2r1aKKfiU8nrSyQdhnF8tVNJxRX44oFZfHRog"
      ];
    };
  };
  services = {
    openssh = {
      enable = true;
      settings = {
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
        ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
    caddy = {
      enable = true;
      # see https://waitwhat.sh/blog/custom_ca_caddy/ for the ca setup
      globalConfig = ''
              	pki {
        		      ca ts_ca {
                  			name ts_ca

        			          root {
                        				cert /etc/caddy/ts_ca/ca.crt
                                key /etc/caddy/ts_ca/ca.key
        			          }
        		      }
        	      }
      '';
      extraConfig = ''
              (tls_ts_ca) {
              	tls {
                		issuer internal {
                    			ca ts_ca
        		        }
        	      }
              } 
      '';
      virtualHosts."bezmuth.uk".extraConfig = ''
        	import tls_ts_ca
                header /.well-known/matrix/* Content-Type application/json
                header /.well-known/matrix/* Access-Control-Allow-Origin *
                respond /.well-known/matrix/server `{"m.server": "matrix.bezmuth.uk:443"}`
                respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.bezmuth.uk"}}`
      '';
    };
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      podman-compose
    ];
  };

  # reboot once a day
  systemd = {
    services.reboot-weekly = {
      description = "Reboot the system";
      serviceConfig.ExecStart = "/run/current-system/sw/bin/reboot";
    };
    timers."reboot-weekly" = {
      wantedBy = [ "timers.target" ];
      description = "Reboot the system every week";
      timerConfig = {
        OnCalendar = "weekly";
        unit = "reboot-weekly";
      };
    };
  };

  security.pki.certificateFiles = [
    ./ca.crt
  ];

  environment.systemPackages = with pkgs; [
    nss # for caddy
  ];

  bzm = {
    common.enable = true;
    hardening.enable = true;
    shellconfig.enable = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
