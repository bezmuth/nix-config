{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
      };
      # Colors (catppuccin-mocha)
      colors = {
        # Default colors
        cursor = {
          text = "0x1E1E2E";
          cursor = "0xF5E0DC";
        };

        primary = {
          # hard contrast: background = '#1d2021'
          background = "#1E1E2E";
          # soft contrast: background = "#32302f"
          foreground = "#CDD6F4";
        };
        # Normal colors
        normal = {
          black = "#45475A"; # surface1
          red = "#F38BA8"; # red
          green = "#A6E3A1"; # green
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#BAC2DE"; # subtext1
        };

        # Bright colors
        bright = {
          black = "#585B70"; # surface2
          red = "#F38BA8"; # red
          green = "#A6E3A1"; # green
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#A6ADC8"; # subtext0
        };
      };
    };
  };
}
