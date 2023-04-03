{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "snore";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bezmuth";
    repo = pname;
    rev = "455bcdeb216b8c0c9d1d9a4740dfaf17235d6a02";
    hash = "sha256-+s5RBC3XSgb8omTbUNLywZnP6jSxZBKSS1BmXOjRF8D=";
  };

  cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtztd=";

  meta = with lib; {
    description = "rss client";
    homepage = "https://github.com/bezmuth/snore";
  };
}
