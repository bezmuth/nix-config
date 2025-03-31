let
  salas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgBhMSIEG+rYUy35D9o8eUE8au+j2nybXE32e5q2uc3";
  mishim = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHVuAgXZTD4uta2/G9CSdJM7cm28PJS2pTGsF9PO6GQ";
  roshar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBI2o2Be33TpGgphq7mDo3XKzAnpPXM2pfJ6vgPI/HqC";
in
{
  "openvpn-env.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "nextcloud.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "default-password.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "cloudflare-token.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "dns-token.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "miniflux-token.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "miniflux-emacs-token.age".publicKeys = [
    mishim
    roshar
  ];
}
