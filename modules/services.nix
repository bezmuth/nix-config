_: {
  services = {
    dbus.enable = true;
    upower.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    snowflake-proxy = {
      enable = true;
      capacity = 100;
    };
  };
}
