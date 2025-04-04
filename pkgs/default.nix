# this used to be self: super:
_: super: {
  # Custom packages
  snore = super.callPackage ./snore { };
  cloudflare-dyndns-custom = super.callPackage ./cloudflare-dyndns { };
}
