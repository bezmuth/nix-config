{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "Salas";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3XWn0EIrX6rRWIIus4c0J3kt2iLKecfj21wbPD+tujIQXxTzBnkKlJE3o32/cvHGmETGozLI04NhXXAL1+mLoPLNIBEpRay2OZTu2/xzhnmN9YyI3QKaI+MmQnn+jZjWk/B9zIz6e9UihUrLFVVIXGci1n8ZT4sdv8Hir7+4u7sTw6kiOlp+ARjLZr8T1UrPR6KDpud/DxPRY2T5c2r89FUv9n9nBvJVWs20nQjeiGr+BXTlUiKl2x2MkE+lEk0rSqkKMfDmAFZNHpytpw9EB3fsw+omMlURHK8aZEi0H61ecFWXbFBF5VAtfjha9yedOR/TYeba4fTtomD1J5CP4qUyhzJrxxIWL7+rsR3dcFoXMDaOYjuc26XU8iCcAtXNuwpGdre5hYYqVQlETXjv8lVgNucwc7HZgLY0MfAo82FR17j7HPpAzOqDh7vISTwsq7bI9bIvQrq8EH3E6U+Lex7wNW9RCDOCJAey09cvksBPgLY3KvOU3n20p+9Qv7uE= bezmuth@fedora"
  ];
  users.users.bezmuth = {
    isNormalUser = true;
    home = "/home/bezmuth";
    description = "Bezmuth";
    extraGroups = [ "wheel" "networkmanager" "postgres" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3XWn0EIrX6rRWIIus4c0J3kt2iLKecfj21wbPD+tujIQXxTzBnkKlJE3o32/cvHGmETGozLI04NhXXAL1+mLoPLNIBEpRay2OZTu2/xzhnmN9YyI3QKaI+MmQnn+jZjWk/B9zIz6e9UihUrLFVVIXGci1n8ZT4sdv8Hir7+4u7sTw6kiOlp+ARjLZr8T1UrPR6KDpud/DxPRY2T5c2r89FUv9n9nBvJVWs20nQjeiGr+BXTlUiKl2x2MkE+lEk0rSqkKMfDmAFZNHpytpw9EB3fsw+omMlURHK8aZEi0H61ecFWXbFBF5VAtfjha9yedOR/TYeba4fTtomD1J5CP4qUyhzJrxxIWL7+rsR3dcFoXMDaOYjuc26XU8iCcAtXNuwpGdre5hYYqVQlETXjv8lVgNucwc7HZgLY0MfAo82FR17j7HPpAzOqDh7vISTwsq7bI9bIvQrq8EH3E6U+Lex7wNW9RCDOCJAey09cvksBPgLY3KvOU3n20p+9Qv7uE= bezmuth@fedora"
    ];
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
