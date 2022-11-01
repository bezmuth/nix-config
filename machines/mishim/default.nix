# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, agenix, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "Mishim"; # Define your hostname.

  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.auto-cpufreq.enable = true;

  systemd.services.mouse-reset = {
    description = "reset trackpad when leaving sleep";
    wantedBy = [ "basic.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    path = with pkgs; [ bash kmod ];
    script = ''
        modprobe -r psmouse && modprobe psmouse
      '';
  };

  # load tskey secret
  age.secrets.tskey.file = ../../secrets/tskey.age;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey file:${config.age.secrets.tskey.path}
    '';
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
