{ config, ... }:
{
  xdg = {
    userDirs = rec {
      enable = true;
      setSessionVariables = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = download;
      download = "${config.home.homeDirectory}/downloads";
      music = download;
      pictures = download;
      projects = "${config.home.homeDirectory}/forks";
      publicShare = projects;
      templates = "${config.home.homeDirectory}/experiments";
      videos = download;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
      };
    };
  };
}
