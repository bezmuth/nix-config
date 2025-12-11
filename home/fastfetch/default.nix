_: {
  programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
        };
        modules = [
          "title"
          "separator"
          "os"
          "uptime"
          "memory"
          "disk"
          "localip"
        ];
      };
    };
    fish.interactiveShellInit = ''
      fastfetch
    '';
  };
}
