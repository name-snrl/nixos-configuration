{ pkgs, ... }: {
  programs.nano.enable = false;
  environment = {
    systemPackages = with pkgs; [ nvim-full ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      DFT_DISPLAY = "inline"; # difftastic mode

      LESS = "FRSM";
      SYSTEMD_LESS = "FRSM";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
