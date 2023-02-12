{ pkgs, ... }: {
  environment = {
    pathsToLink = [ "/share" ];
    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # misc
      TERMINAL = "alacritty";
      MENU = "wofi -d";
      EDITOR = "nvim";
      BROWSER = "nvim";
      QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue
    };
  };
}
