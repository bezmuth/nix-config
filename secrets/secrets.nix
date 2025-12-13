let
  salas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEKh2ESQFnx5rBZ3ytgE3i7YFwVZvoRxihwYtji58uH0";
  mishim = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6zoHZ2w6Mo6KOiubft6bjHhOZTCnzRJm2Yp2Xk8YPv";
  roshar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5g+dx2r1aKKfiU8nrSyQdhnF8tVNJxRX44oFZfHRog";
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
  "miniflux-token.age".publicKeys = [
    salas
    mishim
    roshar
  ];
  "miniflux-emacs-token.age".publicKeys = [
    mishim
    roshar
  ];
  "tailscale.age".publicKeys = [
    salas
    mishim
    roshar
  ];
}
