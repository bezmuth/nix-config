{pkgs, ...}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = "${pkgs.pfetch-rs}/bin/pfetch";
    };
  };
  home.shellAliases = {
    rb = "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
    ub = "PASSTWD=$(pwd) && cd ~/nix-config/ && nix develop --command bash -c 'rebuild' && cd \${PASTWD}";
  };
}
