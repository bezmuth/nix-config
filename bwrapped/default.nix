{
  pkgs,
  nixpak,
  inputs,
}:

{
  inherit
    (import ./hello.nix {
      inherit pkgs nixpak;
    })
    hello
    hello-env
    ;

  # future packages:
  inherit (import ./librewolf.nix { inherit pkgs nixpak; })
    librewolf
    ;

  inherit (import ./tor-browser.nix { inherit pkgs nixpak; })
    tor-browser
    ;

  inherit (import ./thunderbird.nix { inherit pkgs nixpak; })
    thunderbird
    ;

  inherit (import ./agenix.nix { inherit pkgs nixpak inputs; })
    agenix
    ;

}
