{ config, vars, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      setSessionVariables = true;
      desktop = "${config.home.homeDirectory}/${vars.users.master.dirs.desktop}";
      documents = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      download = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      music = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      pictures = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      projects = "${config.home.homeDirectory}/${vars.users.master.dirs.forks}";
      publicShare = "${config.home.homeDirectory}/${vars.users.master.dirs.forks}";
      templates = "${config.home.homeDirectory}/${vars.users.master.dirs.experiments}";
      videos = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
      };
    };
  };
}
