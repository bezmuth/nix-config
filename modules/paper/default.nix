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
      package = pkgs.fabricServers.fabric-1_21_4;

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/IXeiAH6H/fabric-api-0.118.5%2B1.21.4.jar";
              hash = "sha512-Wte5HzB3/dQS0wsIzJPdtiWygcPcObfKJJV5AZMYB2lf2gRcBAmQ4b3XQcW/OE8h+4wTagSrH7maCLONNh+6aw==";
            };
            Distant-Horizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/DTFSZmMF/DistantHorizons-neoforge-fabric-2.3.0-b-1.21.4.jar";
              hash = "sha512-czfUhs3j3UP1vtX4EncXDQ2rQlf101Xh3IjVz7VXeoWSo1o9+A014eyBt5nrx7OYw0jOxuc6DTfnlSiD5J0G3Q==";
            };
            Tick-Stasis = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/t6XBQ2xn/versions/fDbxgNHz/tick-stasis-1.1.1.jar";
              hash = "sha512-NG+ufg8aYmNlJakzFkOsQ0O3gcJA2275uv4bOildJNEx0rSyDO+O3DODXpBp/K8cLis86c7ZouxuTj2Cdw9Sxg==";
            };
          }
        );
      };
    };
  };
}
