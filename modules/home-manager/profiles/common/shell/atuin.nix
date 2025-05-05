{ lib, config, ... }:
{
  programs.atuin = lib.mkIf (config.home.username != "root") {
    enable = true;
    daemon.enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
      style = "compact";
      invert = true;
      inline_height = 15;
      show_help = false;
      show_tabs = false;
      enter_accept = true;
      prefers_reduced_motion = true;
      keys.scroll_exits = false;
    };
  };
}
