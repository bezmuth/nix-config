{
  localPort ? 0,
  url ? "rm.bezmuth.uk",
  ...
}:
{
  services = {
    rmfakecloud = {
      enable = true;
      storageUrl = "https://${url}";
      port = localPort;
    };
  };
}
