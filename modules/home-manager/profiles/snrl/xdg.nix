{ config, vars, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/${vars.users.master.dirs.desktop}";
      publicShare = "${config.home.homeDirectory}/${vars.users.master.dirs.forks}";
      templates = "${config.home.homeDirectory}/${vars.users.master.dirs.experiments}";
      download = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      documents = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      music = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      pictures = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
      videos = "${config.home.homeDirectory}/${vars.users.master.dirs.downloads}";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "image/jpeg" = "swayimg.desktop";
        "image/png" = "swayimg.desktop";
      };
    };
  };
}
