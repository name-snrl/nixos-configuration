{
  environment = {
    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # misc
      TERMINAL = "alacritty"; # TODO remove when xdg-terminal-exec will be set
      MENU = "wofi -d";
      EDITOR = "nvim";
    };
  };
}
