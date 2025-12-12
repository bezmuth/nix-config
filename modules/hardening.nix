{ config, lib, ... }:
with lib;
{
  options.bzm.hardening = {
    enable = mkEnableOption "basic hardening";
  };
  config = mkIf config.bzm.hardening.enable {
      security = {
        # use nix-mineral for more hardening?
        polkit.enable = true;
        sudo.enable = false;
        wrappers = {
          su.setuid = lib.mkForce false;
          sg.setuid = lib.mkForce false;
          fusermount.setuid = lib.mkForce false;
          fusermount3.setuid = lib.mkForce false;
          mount.setuid = lib.mkForce false;
          umount.setuid = lib.mkForce false;
          pkexec.setuid = lib.mkForce false;
          newgrp.setuid = lib.mkForce false;
          newgidmap.setuid = lib.mkForce false;
          newuidmap.setuid = lib.mkForce false;
          chsh.setuid = lib.mkForce false;
        };
        pki.certificates = [
          ''
            -----BEGIN CERTIFICATE-----
            MIICWTCCAUGgAwIBAgIRAMXiExlrYsgpbDun5CkgQHAwDQYJKoZIhvcNAQELBQAw
            EDEOMAwGA1UEAwwFdHNfY2EwHhcNMjUxMjA2MDgzODEzWhcNMjUxMjEzMDgzODEz
            WjAjMSEwHwYDVQQDDBh0c19jYSAtIEVDQyBJbnRlcm1lZGlhdGUwWTATBgcqhkjO
            PQIBBggqhkjOPQMBBwNCAAS3ydfRHSUwqY05K74fnUgxMqpzOV4qg6Gcjgm0MD+/
            VcO4Ig+CWce0+SBvOvaSraBC1H1cZIfSRHUg1l9DLlhgo2YwZDAOBgNVHQ8BAf8E
            BAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUey+RoNQjj+YmnThK
            qr/yZY0xQgEwHwYDVR0jBBgwFoAUHOJM3ZWbeiZPvS+dIlc00TEP2eQwDQYJKoZI
            hvcNAQELBQADggEBAIBwqjZ7G9/+SfHsclRogHrTlONb9oL3cHv6qE+QcpcB2hRD
            FVs0m6NGGxyvLQ/ZIjzxsDa0cWfMJsP8p72xw3p85SVz8uM4eW88hWBc1K9MZz6K
            hkD5tVWePoNbKegl98qkA6R1jb0jym/pJjBcjOIosxbKuDlSTQdLG+kEwOeWwzf6
            lCxWVi4i2G1a0XTUE8D3JiG/GiDap9hLRrh7eKvKkf5qReC/6MfAtCD+4ttSNbRN
            0141D8NBuu8Or+UTRzBIZ6158ECYmalhNtD86Ckx58xQT6NdPrFcI5bfaJctPWlK
            np86RQupqlltsz7MKq7jfybv4hAAPW3sdJi/RYA=
            -----END CERTIFICATE-----
          ''
        ];
      };
    };
}
