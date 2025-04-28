{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "waybar-module-pomodoro";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Andeskjerf";
    repo = pname;
    rev = "3d42cbd69edce0b82ff79d64e1981328f2e86842";
    hash = "sha256-BF7JqDIVDLX66VE/yKmb758rXnfb1rv/4hwzf3i0v5g=";
  };

  doCheck = false;

  cargoHash = "sha256-N1xuKml9cRDix0SOVBKJydTN35EKk+ohnXhInsMG3HY=";
}
