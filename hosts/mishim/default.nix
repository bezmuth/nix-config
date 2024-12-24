{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "Mishim"; # Define your hostname.

  services.thermald.enable = true;
  hardware = {
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  systemd.services.mouse-reset = {
    description = "reset trackpad when leaving sleep";
    wantedBy = [
      "basic.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    path = with pkgs; [
      bash
      kmod
    ];
    script = ''
      modprobe -r psmouse && modprobe psmouse
    '';
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
