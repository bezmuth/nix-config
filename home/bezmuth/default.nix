{
  pkgs,
  ...
}:
{
  imports = [
    ../fish
    ../sway
    ../fastfetch
    ../helix
  ];
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "bezmuth";
    homeDirectory = "/home/bezmuth";
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      (writeShellScriptBin "scrcpy-desktop.sh" ''
        ${builtins.readFile ./scrcpy-desktop.sh}
      '')
      (writeShellScriptBin "video.sh" ''
        ${builtins.readFile ./video.sh}
      '')
      (writeShellScriptBin "radio.sh" ''
        ${builtins.readFile ./radio.sh}
      '')
      (writeShellScriptBin "idle.sh" ''
        ${builtins.readFile ./idle.sh}
      '')
    ];
  };

  fonts.fontconfig.enable = true;
  dconf.enable = true;
  services.mpris-proxy.enable = true;

  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "pink"; };
    };
  };

  programs.alacritty.enable = true;
  programs.zathura.enable = true;
}
