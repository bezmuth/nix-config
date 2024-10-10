self: super: {
  # Custom packages
  v = {
    glitch-soc = super.callPackage ./glitch-soc { };
  };
  #kasts = super.callPackage ./kasts { };
  # font-awesome = (super.callPackage ./font-awesome { }).v6;
  #i2p = super.callPackage ./i2p { };
  #snore = super.callPackage ./snore { };
  #beeper = super.callPackage ./beeper { };
  #lutgen = super.callPackage ./lutgen { };
}
