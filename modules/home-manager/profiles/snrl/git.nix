{ config, ... }:
{
  programs.git = {
    userName = "${config.home.username}";
    userEmail = "Demogorgon-74@ya.ru";
  };
}
