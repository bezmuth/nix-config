{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 80;
      indicator-thickness = 10;
      timestr = "%H:%M:%S";
      datestr = "%Y-%m-%d, %a";
      effect-blur = "16x12";
      effect-vignette = "0.5:0.5";
      fade-in = 0.5;
    };
  };
}
