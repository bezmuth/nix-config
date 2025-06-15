{ pkgs, ... }:
{
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
        pause-when-empty-seconds = 20;
      };

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_5;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/YozemL2T/fabric-api-0.127.0%2B1.21.5.jar";
              hash = "sha256-i3FvHe7M4qbYogp6hlGbXvZ9EdteWBJidbHNb9nlkn4=";
            };
            Distant-Horizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/Mt9bDAs6/DistantHorizons-neoforge-fabric-2.3.2-b-1.21.5.jar";
              hash = "sha256-HJixoCVz/Xs9vkd6jha+wUxGiDqT7F0eQkvKAY4+yEs=";
            };
            Tick-Stasis = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/t6XBQ2xn/versions/fDbxgNHz/tick-stasis-1.1.1.jar";
              hash = "sha256-BYGJG1GOy+WLQhSRmJNMRmlG1QWjUbd7Jyffwhvf5cY=";
            };
          }
        );
      };
    };
  };
}
