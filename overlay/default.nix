inputs: final: prev:

let
  inherit (final) system lib;
in

import ./nvim.nix { inherit inputs prev; } //
{
  scripts = import ./scripts.nix prev;

  inherit (inputs.shlyupa.packages.${system})
    kotatogram-desktop-with-webkit
    exo2
    ;

  sway-assign-cgroups = prev.callPackage ../pkgs/sway-assign-cgroups.nix { };

  page = with prev; let
    less = writeShellApplication {
      name = "less";
      runtimeInputs = [ page ncurses ];
      text = ''exec page -O "$(tput lines)" "$@"'';
    };
  in
  symlinkJoin { name = "page"; paths = [ less page ]; };

  imv = with prev; with builtins;
    let
      f = data: fetchurl data;
      listOfAttrs = fromJSON (readFile ./wallhaven-collection.json);
      wallpapers = concatStringsSep " " (map f listOfAttrs);

      imv-wp = writeShellScriptBin "imv-wp" ''
        ${imv}/bin/imv ${wallpapers}
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
    symlinkJoin {
      name = "imv";
      paths = [ imv.man imv imv-wp desktop ];
    };

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
