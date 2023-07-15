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
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };
  # preview support in filepicker
  environment.systemPackages = with pkgs.plasma5Packages; [ kio kio-extras ];
  environment.sessionVariables.GTK_USE_PORTAL = "1";
}
