# this used to be self: super:
_: super: {
  # Custom packages
  snore = super.callPackage ./snore { };
  cloudflare-dyndns-custom = super.callPackage ./cloudflare-dyndns { };
  waybar-module-pomodoro = super.callPackage ./waybar-module-pomodoro { };
  azahar = super.callPackage ./azahar {  };
}
