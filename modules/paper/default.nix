{
  pkgs,
  ...
}: {
  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.paper = {
      enable = true;
      autoStart = true;
      jvmOpts = "-Xmx8G -Xms4G";

      whitelist = {
        reocha = "703317f9-90be-47cd-a9c7-8a4cc8215916";
      };

      serverProperties = {
        server-port = 25565;
        difficulty = 3;
        gamemode = 0;
        max-players = 5;
        motd = "NixOS Minecraft server!";
        white-list = true;
        enable-rcon = false;
        hardcore = true;
        force-gamemode = true;
        view-distance = 12;
      };

      # Specify the custom minecraft server package
      package = pkgs.paperServers.paper-1_21;
    };
  };
}
