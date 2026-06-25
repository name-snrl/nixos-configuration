{ config, ... }:
{
  programs.git.settings = {
    user.name = "${config.home.username}";
    user.email = "Demogorgon-74@ya.ru";
  };
}
