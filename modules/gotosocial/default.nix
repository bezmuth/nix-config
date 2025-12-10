{
  localPort ? 0,
  url ? "social.bezmuth.uk",
  ...
}:
{
  services = {
    gotosocial = {
      enable = true;
      settings = {
        host = "${url}";
        bind-address = "0.0.0.0";
        port = localPort;
      };
    };
  };
}
