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
        hardcore = false;
        force-gamemode = true;
        view-distance = 10;
        pause-when-empty-seconds = 20;
      };

      # Specify the custom minecraft server package
      package = pkgs.fabricServers.fabric-1_21_8;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/zhzhM2yQ/fabric-api-0.130.0%2B1.21.8.jar";
              hash = "sha256-k/+F7dZLgCltzTcttFJaMzJoDKnAeQ4o6StVBSkBdYk=";
            };
            Distant-Horizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9yaYzpcr/DistantHorizons-2.3.4-b-1.21.8-fabric-neoforge.jar";
              hash = "sha256-rbtFZ1PzCojLTtyiVpb0EJcbvSkl8xAr4Ae2bxuLoY8=";
            };
            Tick-Stasis = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/t6XBQ2xn/versions/fDbxgNHz/tick-stasis-1.1.1.jar";
              hash = "sha256-BYGJG1GOy+WLQhSRmJNMRmlG1QWjUbd7Jyffwhvf5cY=";
            };
            # Optimises a lot of the same things as lithium and ferrite core, I think it was causing breakage
            Moonrise = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/KOHu7RCS/versions/70KoSrYl/Moonrise-Fabric-0.6.0-beta.1%2B45edfd7.jar";
              hash = "sha256-kVRkXtnxDojsFnBj0FXQ0rjDbQNn4PEyfD9ilaihvj4=";
            };
          }
        );
      };
    };
  };
}
