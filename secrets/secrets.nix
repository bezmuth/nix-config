let
  salas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgBhMSIEG+rYUy35D9o8eUE8au+j2nybXE32e5q2uc3";
  mishim = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHbPVlywhuui3+MSBP/cMo3PsbDC4L+UzD7cmp6f306";
  roshar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHuTuWP4QNFb3ZU/QksaItFuICLWMs+fJ33aXJNC0WR";
in {
  "openvpn-env.age".publicKeys = [salas mishim roshar];
  "nextcloud.age".publicKeys = [salas mishim roshar];
  "default-password.age".publicKeys = [salas mishim roshar];
  "cloudflare-token.age".publicKeys = [salas mishim roshar];
  "dns-token.age".publicKeys = [salas mishim roshar];
  "miniflux-token.age".publicKeys = [salas mishim roshar];
}
