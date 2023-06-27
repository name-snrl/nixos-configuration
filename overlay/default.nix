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
    desktop = writeTextFile {
      name = "imv-wp.desktop";
      destination = "/share/applications/imv-wp.desktop";
      text = ''
        [Desktop Entry]
        Name=imv-wp
        GenericName=Image viewer
        Exec=${imv-wp}/bin/imv-wp
        Terminal=false
        Type=Application
        Categories=Graphics;2DGraphics;Viewer;
      '';
    };
  in
  symlinkJoin { name = "imv"; paths = [ imv.man imv imv-wp desktop ]; };

  # TODO create a pr to fix the pkg
  # and fix gtk2 theme colors
  graphite-gtk-theme = prev.graphite-gtk-theme.overrideAttrs (_: {
    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      name= ./install.sh \
        --tweaks darker nord \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
  });

} // inputs.self.lib.mkSymlinks prev {
  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  alacritty = "xterm";
  gojq = "jq";
}
