{ config, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/desktop";
      publicShare = "${config.home.homeDirectory}/forks";
      templates = "${config.home.homeDirectory}/experiments";
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/downloads";
      pictures = "${config.home.homeDirectory}/downloads";
      videos = "${config.home.homeDirectory}/downloads";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/x-fictionbook+xml" = "sioyek.desktop";
        "application/pdf" = "sioyek.desktop";
        "text/plain" = "nvim.desktop";
        "image/jpeg" = "swayimg.desktop";
        "image/png" = "swayimg.desktop";
      };
    };
  };
}
