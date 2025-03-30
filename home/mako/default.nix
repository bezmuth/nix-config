_: {
  services.mako = {
    enable = true;
    anchor = "top-right";
    extraConfig = ''
      # https://github.com/catppuccin/mako/blob/main/src/mocha
      # Colors
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#f5c2e7
      progress-color=over #313244
      icons=1
      ignore-timeout=1
      default-timeout=5000
      border-size=2

      [urgency=high]
      border-color=#fab387
      default-timeout=10000
      border-size=3

    '';
  };
}
