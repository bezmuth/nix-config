# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
args@{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  networking.hostName = "Salas";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../../modules/seedbox args)
    (import ../../modules/ts-exitnode args)
    (import ../../modules/jellyfin args)
    (import ../../modules/audiobookshelf (args // { localPort = 10000; }))
    (import ../../modules/calibre-web (args // { localPort = 10001; }))
    (import ../../modules/miniflux (args // { localPort = 10002; }))
    (import ../../modules/gotosocial (args // { localPort = 10003; }))
    (import ../../modules/actual (args // { localPort = 10004; }))
    (import ../../modules/nextcloud (args // { localPort = 10005; }))
    (import ../../modules/rmfakecloud (args // { localPort = 10006; }))
    (import ../../modules/matrix (args // { localPort = 10007; }))
    (import ../../modules/ntfy (args // { localPort = 10008; }))
    ../../modules/paper
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

  # Bootloader.

  networking.networkmanager.enable = true;

  age = {
    identityPaths = [ "/home/bezmuth/.ssh/id_ed25519" ];
    secrets.cloudflare-token.file = ../../secrets/cloudflare-token.age;
    secrets.dns-token.file = ../../secrets/dns-token.age;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "benkel97@protonmail.com";
    certs."bezmuth.uk" = {
      domain = "bezmuth.uk";
      extraDomainNames = [ "*.bezmuth.uk" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.age.secrets.dns-token.path;
      };
    };
  };
  users = {
    groups.srv-data = { };
    users = {
      caddy.extraGroups = [ "acme" ];
      "bezmuth".openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHVuAgXZTD4uta2/G9CSdJM7cm28PJS2pTGsF9PO6GQ"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBI2o2Be33TpGgphq7mDo3XKzAnpPXM2pfJ6vgPI/HqC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqo8BiAIeHSZ/UUoBqODHlSZH2IWvBfzxd5lF/81CQB"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgRppXXzym7N0aSD/IwE7oFVq5QjVf+31crFhpWXO7g"
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
    cloudflare-dyndns = {
      enable = true;
      domains = [
        "bezmuth.uk"
        "social.bezmuth.uk"
        "miniflux.bezmuth.uk"
        "calibre.bezmuth.uk"
        "rm.bezmuth.uk"
      ];
      apiTokenFile = config.age.secrets.cloudflare-token.path;
      proxied = true;
      deleteMissing = true;
    };
    caddy = {
      enable = true;
      virtualHosts."bezmuth.uk".extraConfig = ''
        header /.well-known/matrix/* Content-Type application/json
        header /.well-known/matrix/* Access-Control-Allow-Origin *
        respond /.well-known/matrix/server `{"m.server": "matrix.bezmuth.uk:443"}`
        respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.bezmuth.uk"}}`
      '';
    };
  };
  # for minecraft
  systemd.services."cloudflare-dyndns-mc" = {
    description = "mc";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      CLOUDFLARE_DOMAINS = "mc.bezmuth.uk";
    };
    serviceConfig = {
      startAt = "*:0/5";
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "cloudflare-dyndns-mc";
      Environment = [ "XDG_CACHE_HOME=%S/cloudflare-dyndns-mc/.cache" ];
      LoadCredential = [
        "apiToken:${config.age.secrets.cloudflare-token.path}"
      ];
    };
    script =
      let
        args = [ "--cache-file /var/lib/cloudflare-dyndns-mc/ip.cache" ];
      in
      ''
        export CLOUDFLARE_API_TOKEN_FILE=''${CREDENTIALS_DIRECTORY}/apiToken

        exec ${lib.getExe pkgs.cloudflare-dyndns} ${toString args}
      '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
    25565
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
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

  system.stateVersion = "24.11"; # Did you read the comment?
}
