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
  # NoSript
  "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4633540/noscript-latest.xpi";
    installation_mode = "force_installed";
  };
  # LibRedirect
  "7esoorv3@alefvanoon.anonaddy.me" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/file/4522826/libredirect-latest.xpi";
    installation_mode = "force_installed";
  };
}
