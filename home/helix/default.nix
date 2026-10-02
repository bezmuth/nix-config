_: {
  programs = {
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        editor = {
          line-number = "relative";
          lsp = {
            display-messages = true;
          };
        };
        theme = "ayu_evolve";
      };
    };
  };
}
