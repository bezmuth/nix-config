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
      package = pkgs.fabricServers.fabric-1_21_7;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/JIZogEYa/fabric-api-0.128.2%2B1.21.7.jar";
              hash = "sha256-YVCRbpbouYCX+k7BYhgparrE6N4Jcwfq1q2e/GfKTQ4=";
            };
            # Distant-Horizons = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/uCdwusMi/versions/Mt9bDAs6/DistantHorizons-neoforge-fabric-2.3.2-b-1.21.5.jar";
            #   hash = "sha256-HJixoCVz/Xs9vkd6jha+wUxGiDqT7F0eQkvKAY4+yEs=";
            # };
            # Tick-Stasis = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/t6XBQ2xn/versions/fDbxgNHz/tick-stasis-1.1.1.jar";
            #   hash = "sha256-BYGJG1GOy+WLQhSRmJNMRmlG1QWjUbd7Jyffwhvf5cY=";
            # };
            Moonrise = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/KOHu7RCS/versions/deKWI7rK/Moonrise-Fabric-0.5.0-beta.1%2B90ce197.jar";
              hash = "sha256-0Go7hZOUG9mel0J/dJp21cT8r3fJoTqL4YsaXFA+BWs=";
            };
            # Ferritecore = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
            #   hash = "sha256-K5C/AMKlgIw8U5cSpVaRGR+HFtW/pu76ujXpxMWijuo=";
            # };
            Krypton = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
              hash = "sha256-uGYia+H2DPawZQxBuxk77PMKfsN8GEUZo3F1zZ3MY6o=";
            };
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/77EtzYFA/lithium-fabric-0.18.0%2Bmc1.21.7.jar";
              hash = "sha256-uUwXEFqZaZvikSv2LbfjT+LwJjJH1JguRAzwpmEwJqE=";
            };
          }
        );
      };
    };
  };
}
