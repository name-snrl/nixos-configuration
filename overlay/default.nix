inputs: final: prev:

let
  inherit (final) system;
in

import ./nvim.nix { inherit inputs prev; } //
{
  scripts = import ./scripts.nix prev;

  inherit (inputs.shlyupa.packages.${system})
    kotatogram-desktop-with-webkit
    exo2
    ;

  where-is-my-sddm-theme = prev.libsForQt5.callPackage ../pkgs/where-is-my-sddm-theme { };

  openvpn3 = prev.openvpn3.overrideAttrs (_: {
    postInstall = ''
      rm -rf $out/var/lib/openvpn3
      ln -sf /var/lib/openvpn3 $out/var/lib/openvpn3
    '';
  });

  xdragon = with prev; let
    dg = writeShellApplication {
      name = "dg";
      runtimeInputs = [ xdragon ];
      text = ''dragon -T "$@" &'';
    };
  in
  symlinkJoin { name = "xdragon"; paths = [ xdragon dg ]; };

  page = with prev; let
    less = writeShellApplication {
      name = "less";
      runtimeInputs = [ page ncurses ];
      text = ''exec page -O "$(tput lines)" "$@"'';
    };
  in
  symlinkJoin { name = "page"; paths = [ page less ]; };

  imv = with prev; let
    wallpapers = with builtins;
      concatStringsSep " " (map
        (data: fetchurl data)
        (fromJSON (readFile ./wallhaven-collection.json)));
    imv-wp = writeShellScriptBin "imv-wp" ''
      exec ${imv}/bin/imv ${wallpapers}
    '';
    desktop = makeDesktopItem {
      name = "imv-wp";
      desktopName = "imv-wp";
      genericName = "Image viewer";
      exec = "${imv-wp}/bin/imv-wp";
      categories = [ "Graphics" "2DGraphics" "Viewer" ];
      icon = "multimedia-photo-viewer";
    };
  in
  symlinkJoin { name = "imv"; paths = [ imv.man imv imv-wp desktop ]; };

  graphite-gtk-theme = prev.graphite-gtk-theme.overrideAttrs (_: {
    version = "flake";
    src = inputs.graphite-gtk;

    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      name= ./install.sh \
        --size compact \
        --tweaks darker nord rimless \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
  });

  graphite-kde-theme = prev.graphite-kde-theme.overrideAttrs (_: {
    version = "flake";
    src = inputs.graphite-kde;

    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      substituteInPlace install.sh \
        --replace '$HOME/.local' $out \
        --replace '$HOME/.config' $out/share
      name= ./install.sh --theme nord --rimless

      runHook postInstall
    '';
  });

} // inputs.self.lib.mkSymlinks prev {
  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  alacritty = "xterm";
  gojq = "jq";
}
