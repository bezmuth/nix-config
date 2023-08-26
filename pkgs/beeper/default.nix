# https://git.sr.ht/~fd/nix-configs/tree/main/item/custompkgs/beeper/default.nix
{ pkgs ? import <nixpkgs> { }, ... }:
with pkgs;
let
  pname = "beeper";
  version = "3.71.16";
  name = "${pname}-${version}";

  src = fetchurl {
    url =
      "https://download.todesktop.com/2003241lzgn20jd/${pname}-${version}.AppImage";
    # Get hashes from https://download.todesktop.com/2003241lzgn20jd/latest-linux.yml
    hash =
      "sha512-RuZq2zHbvHo6O5j6w9TmiEGHW3Flluhl5xNReZ4xDbg+0/SF8W/x6UHSu8tBBzkdlXjKQzX2Dc/fB/Ohh3kkNA==";
  };
  appimage = appimageTools.wrapType2 { inherit version pname src; };
  appimageContents = appimageTools.extractType2 { inherit version pname src; };

in stdenvNoCC.mkDerivation rec {
  inherit version pname name;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mv bin/${name} bin/${pname}

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop --replace "AppRun" "${pname}"

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Beeper is a universal chat app. With Beeper, you can send and receive messages to friends, family and colleagues on many different chat networks.";
    homepage = "https://beeper.com";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = [ "x86_64-linux" ];
  };
}
