{ lib, pkgs, ... }: {
  programs.nano.enable = false;
  programs.less.enable = lib.mkForce false;
  environment = {
    systemPackages = with pkgs; [
      nvim-full
      page # `page` contains alias to `less`
    ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
