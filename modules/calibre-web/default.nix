{
  localPort ? 0,
  ...
}:
{
  services = {
    calibre-web = {
      group = "srv-data";
      enable = true;
      listen = {
        ip = "0.0.0.0";
        port = localPort;
      };
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
      };
    };
  };
}
