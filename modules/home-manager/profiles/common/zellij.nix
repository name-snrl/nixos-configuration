{
  home.shellAliases.z = "zellij";
  programs.zellij = {
    enable = true;
    # TODO configure me
    settings = {
      pane_frames = false;
      theme = "one-half-dark";
      default_layout = "compact";
    };
    #enableFishIntegration = true;
  };
}
