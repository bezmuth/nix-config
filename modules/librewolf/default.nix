# Mostly taken from https://github.com/pierrot-lc/librewolf-nix
{
  pkgs,
  config,
  lib,
  ...
}:
let
  extensions = import ./extensions.nix;
in
{
  config = lib.mkIf config.bzm.desktop.enable {
    environment.systemPackages = [
      (pkgs.wrapFirefox pkgs.librewolf-unwrapped {
        inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
        wmClass = "LibreWolf";
        libName = "librewolf";
        # Extra prefs can be found at `about:config`.
        extraPrefs =
          # javascript
          ''
            // pref("gfx.canvas.accelerated", true);
            // pref("gfx.webrender.enabled", true);
            // pref("webgl.disabled", false);

            pref("accessibility.force_disabled", 1);
            pref("browser.aboutConfig.showWarning", false);
            pref("browser.toolbars.bookmarks.visibility", "always");
            pref("extensions.install_origins.enabled", true);
            pref("browser.bookmarks.addedImportButton", false);

            pref("privacy.resistFingerprinting.letterboxing", false);
            pref("middlemouse.paste", false);
            pref("general.autoScroll", true);
          '';

        # Documentation about policies options can be found at `about:policies#documentation`.
        # You can also have a look here: https://github.com/mozilla/policy-templates/.
        extraPolicies = {
          ExtensionSettings = extensions;

          Cookies = {
            Allow = [
              "https://enafore.social/"
              "https://nextcloud.bezmuth.uk/"
              "https://miniflux.bezmuth.uk/"
              "https://jellyfin.bezmuth.uk/"
              "https://social.bezmuth.uk/"
              "https://navi.bezmuth.uk/"
              "https://proton.me/"
              "https://github.com/"
            ];
          };
          EnableTrackingProtection = {
            Exceptions = [
            ];
          };
        };
      })
    ];
  };
}
