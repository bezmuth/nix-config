# Extensions are obtained thanks to the guide here: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265.
# Check `about:support` for extension/add-on ID strings. Then find the
# installation url by donwloading the extension file (instead of installing it
# directly). Always install the latest version of the extensions by using the
# "latest" tag in the download url.
{
  # Defund Wikipedia
  "{9d6e7f41-8d33-4145-a164-5ca4358c7960}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/3617936/defund_wikipedia-latest.xpi";
    installation_mode = "force_installed";
  };
  # Refined GitHub
  "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4317387/refined_github-latest.xpi";
    installation_mode = "force_installed";
  };
  # Floccus
  "floccus@handmadeideas.org" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4431645/floccus-latest.xpi";
    installation_mode = "force_installed";
  };
  # Proton Pass
  "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4433286/proton_pass-latest.xpi";
    installation_mode = "force_installed";
  };
  # Vimium
  "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-latest.xpi";
    installation_mode = "force_installed";
  };
  # Youtube High Definition
  "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4344731/youtube_high_definition-latest.xpi";
    installation_mode = "force_installed";
  };
  # Sponsor block
  "sponsorBlocker@ajay.app" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4424639/sponsorblock-latest.xpi";
    installation_mode = "force_installed";
  };
  # librewolf seems to be a bit broken https://github.com/NixOS/nixpkgs/issues/344417
  # Duck Duck go
  "jid1-ZAdIEUB7XOzOJw@jetpack" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
    installation_mode = "force_installed";
  };
}
