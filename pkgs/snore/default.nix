{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "snore";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bezmuth";
    repo = pname;
    rev = "014b5646ba0f4166ed2d0a96984cf4d5788aa1d2";
    hash = "sha256-l0yfmjC6J16ewqTrZgfvTNZnSUXVDKPsrJ+HqUvT1OI=";
  };

  cargoHash = "sha256-foiXvIzypfZnZ7AmNfT6UYHg9YRt18QjWIJhfmLYK1w=";

  meta = with lib; {
    description = "rss client";
    homepage = "https://github.com/bezmuth/snore";
  };
}
