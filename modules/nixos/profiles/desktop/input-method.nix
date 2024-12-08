/*
  TODO this module was created as an alternative that would be compatible with
  both kde and sway. So, should we revert to the nixpkgs module after removing
  sway?

  I don't like the input-method modules from nixpkgs, so I wrote my own,
  following the official documentation:

  https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland

  - fcitx5 only
  - first-class wayland support
  - sway support
  - environment.sessionVariables instead environment.variables
  - this module assumes that your DE supports XDG Autostart, so there are no
  additional services like those created by home-manager
*/
{ pkgs, ... }:
let
  fcitx5-package = with pkgs; qt6Packages.fcitx5-with-addons.override { addons = [ fcitx5-mozc ]; };
  gtk_cache =
    v:
    pkgs.runCommandLocal "gtk${v}-immodule.cache"
      {
        buildInputs = [
          pkgs.${"gtk" + v}
          fcitx5-package
        ];
      }
      ''
        mkdir -p $out/etc/gtk-${v}.0/
        GTK_PATH=${fcitx5-package}/lib/gtk-${v}.0/ gtk-query-immodules-${v}.0 > $out/etc/gtk-${v}.0/immodules.cache
      '';
in
{
  environment = {
    systemPackages = [
      fcitx5-package
      (gtk_cache "2")
      (gtk_cache "3")
    ];
    sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5-package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
      QT_IM_MODULES = "wayland;fcitx;ibus";
      # not all packages in nixpkgs includes --enable-wayland-ime flag
      # p.s. sway doesn't support text-input-v1, so this won't work in sway anyway
      #NIXOS_OZONE_WL = "1";
    };
  };

  programs.sway.extraSessionCommands = ''
    export QT_IM_MODULE=fcitx
  '';
}
