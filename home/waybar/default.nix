{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # mocha
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      window#waybar {
        background-color: @base;
        border-bottom: @pink;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      #workspaces button {
        padding: 0px 1px 0px 1px;
      }

      #workspaces button.focused {
        box-shadow: inset 0 -3px @pink;
      }

      #scratchpad {
        background-color: @base;
        color: @text;
      }
      #custom-spotify-metadata {
        background-color: @surface0;
        color: @text;
      }
      #custom-spotify-metadata.playing {
        background-color: @green;
        color: @base;
      }
      #clock {
        background-color: @surface0;
        color: @text;
      }
      #battery {
          background-color: @green;
          color: @base;
      }
      #temperature {
          background-color: @maroon;
          color: @base;
      }
      #memory {
          background-color: @sky;
          color: @base;
      }
      #network {
          background-color: @blue;
          color: @base;
      }
      #tray {
          background-color: @surface0;
          color: @base;
      }
      #cpu {
          background-color: @pink;
          color: @base;
      }
      #pulseaudio {
          background-color: @rosewater;
          color: @base;
      }
      #pulseaudio.muted {
          background-color: @surface0;
          color: @rosewater;
      }
      #power-profiles-daemon.performance {
          font-size: 18px;
          background-color: @red;
          color: @base;
      }
      #power-profiles-daemon.power-saver {
          font-size: 18px;
          background-color: @green;
          color: @base;
      }
      #power-profiles-daemon.balanced {
          font-size: 18px;
          background-color: @blue;
          color: @base;
      }
      #backlight {
          background-color: @yellow;
          color: @base;
      }
    '';
    settings = [
      {
        height = 20;
        layer = "top";
        position = "top";
        tray = {
          spacing = 10;
        };
        mode = "dock";
        modules-center = [ "clock" ];
        modules-left = [ "sway/workspaces" ];
        modules-right = [
          "custom/spotify-metadata"
          "tray"
          "power-profiles-daemon"
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
        ];
        "backlight" = {
          format = "{percent}% 󰌵";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+";
          tooltip = false;
        };
        "sway/scratchpad" = {
          format = "{icon}";
          show-empty = false;
          format-icons = [
            ""
            ""
          ];
        };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          interval = 2;
          format = "{usage}% ";
          tooltip = false;
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            default = "󰓅";
            performance = "󰓅";
            balanced = "󰾅";
            power-saver = "󰾆";
          };
        };
        memory = {
          format = "{}% ";
        };
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };
        "custom/spotify-metadata" = {
          format = " {}   ";
          max-length = 100;
          interval = 1;
          return-type = "json";
          exec = pkgs.writeShellScript "metadata.sh" ''
            status=$(${pkgs.playerctl}/bin/playerctl -p spotify status)
            artist=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata xesam:artist)
            title=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata xesam:title)
            album=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata xesam:album)
            time=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata --format '{{duration(position)}}|{{duration(mpris:length)}}')
            if [[ -z $status ]]
            then
               # spotify is dead, we should die to.
               exit
            fi
            if [[ $status == "Playing" ]]
            then
               echo "{\"class\": \"playing\", \"text\": \"$time - $artist - $title\", \"tooltip\": \"$artist - $title - $album\"}"
               /run/current-system/sw/bin/pkill -RTMIN+5 waybar
               exit
            fi
            if [[ $status == "Paused" ]]
            then
               echo "{\"class\": \"paused\", \"text\": \"$time - $artist - $title\", \"tooltip\": \"$artist - $title - $album\"}"
               /run/current-system/sw/bin/pkill -RTMIN+5 waybar
               exit
            fi
          '';
          signal = 5;
          smooth-scrolling-threshold = 1.0;
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          format-icons = [ "" ];
        };
      }
    ];
  };
}
