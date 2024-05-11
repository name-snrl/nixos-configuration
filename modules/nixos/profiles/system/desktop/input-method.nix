{ pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
  programs.sway.extraSessionCommands = ''
    export GTK_IM_MODULE=fcitx # TODO remove on sway 1.9+
    export QT_IM_MODULE=fcitx
  '';
}
