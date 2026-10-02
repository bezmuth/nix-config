# this used to be self: super:
_self: super: {
  # Custom packages
  snore = super.callPackage ./snore { };
  waybar-module-pomodoro = super.callPackage ./waybar-module-pomodoro { };

  #mishim-kernel = super.linuxManualConfig {
  #  inherit (super) stdenv hostPlatform;
  #  inherit (super.linux_latest) src;
  #  version = "${super.linux_latest.version}-custom";

  #    configfile = ../hosts/mishim/kernel-config;
  #   allowImportFromDerivation = true;
  #};

}
