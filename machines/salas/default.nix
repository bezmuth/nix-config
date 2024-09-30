{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "Salas";
  services.openssh.enable = true;
  users.users.bezmuth = {
    isNormalUser = true;
    home = "/home/bezmuth";
    description = "Bezmuth";
    extraGroups = [ "wheel" "networkmanager" "postgres" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 25 ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.extraHosts = ''
    130.162.189.151 femboy.rehab
    130.162.189.151 propaganda.lol
  '';

  environment.systemPackages = [ pkgs.vim pkgs.tailscale pkgs.git ];

  services.mastodon = {
    enable = true;
    #package = pkgs.v.glitch-soc;
    configureNginx = true;
    localDomain = "propaganda.lol";
    smtp.fromAddress = "admin@propaganda.lol";
    mediaAutoRemove.enable = true;
    mediaAutoRemove.olderThanDays = 1;
    mediaAutoRemove.startAt = "daily";
    streamingProcesses = 3;
  };

  # services.nginx = {
  #   enable = true;
  #   # Use recommended settings
  #   recommendedGzipSettings = true;
  #   recommendedOptimisation = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;

  #   # Only allow PFS-enabled ciphers with AES256
  #   sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

  #   virtualHosts."femboy.rehab" = {
  #     addSSL = true;
  #     enableACME = true;
  #     root = "/var/www/femboy.rehab";
  #   };
  # };

  security.acme.certs = { "propaganda.lol".email = "benkel97@protonmail.com"; };
  security.acme.acceptTerms = true;

}
