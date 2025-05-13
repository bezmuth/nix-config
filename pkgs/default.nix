# this used to be self: super:
_: super: {
  # Custom packages
  snore = super.callPackage ./snore { };
  waybar-module-pomodoro = super.callPackage ./waybar-module-pomodoro { };
}
