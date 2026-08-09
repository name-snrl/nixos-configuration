{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-mozc ];
      systemd.enable = false;
      waylandFrontend = true;
      sessionVariables = {
        XMODIFIERS = "@im=fcitx";
        NIXOS_OZONE_WL = 1;
      };
    };
  };
}
