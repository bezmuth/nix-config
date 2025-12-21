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
        max-players = 10;
        motd = "Nixos Minecraft Server";
        white-list = true;
        # enable-rcon = true;
        # "rcon.password" = "eggs";
        hardcore = true;
        force-gamemode = true;
        view-distance = 10;
        pause-when-empty-seconds = 20;
      };

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_11;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/gB6TkYEJ/fabric-api-0.140.2%2B1.21.11.jar";
              hash = "sha256-t8RYO3/EihF5gsxZuizBDFO3K+zQHSXkAnCUgSb4QyE=";
            };
            Distant-Horizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/OmG1jkba/DistantHorizons-2.4.3-b-1.21.11-fabric-neoforge.jar";
              hash = "sha256-pVV2jxE9hRpC3kfmIQ9Nk6cjQma4eGgeQWlzq6Ywevo=";
            };
            # Optimises a lot of the same things as lithium and ferrite core, I think it was causing breakage
            #Moonrise = pkgs.fetchurl {
            #  url = "https://cdn.modrinth.com/data/KOHu7RCS/versions/70KoSrYl/Moonrise-Fabric-0.6.0-beta.1%2B45edfd7.jar";
            #  hash = "sha256-kVRkXtnxDojsFnBj0FXQ0rjDbQNn4PEyfD9ilaihvj4=";
            #};
          }
        );
      };
    };
  };
}
