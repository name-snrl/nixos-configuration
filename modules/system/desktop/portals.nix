{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        max_fps = 60;
        chooser_type = "none";
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
