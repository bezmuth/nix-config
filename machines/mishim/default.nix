# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, agenix, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "Mishim"; # Define your hostname.
  #
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 9999 ];
  networking.firewall.allowedUDPPorts = [ 9999 ];

  services.openssh.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  hardware.cpu.amd.updateMicrocode = true;

  systemd.services.mouse-reset = {
    description = "reset trackpad when leaving sleep";
    wantedBy = [
      "basic.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    path = with pkgs; [ bash kmod ];
    script = ''
      modprobe -r psmouse && modprobe psmouse
    '';
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
