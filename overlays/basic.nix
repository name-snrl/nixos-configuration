inputs: final: prev: {

  inherit (inputs.shlyupa.packages.${prev.system})
    kotatogram-desktop-with-webkit
    exo2
    ;

  neovim-unwrapped = inputs.nvim-nightly.packages.${prev.system}.neovim;

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

  swayimg = with prev; let
    swim-wp = writeShellScriptBin "swim-wp" ''
      exec ${swayimg}/bin/swayimg --fullscreen --all ${wallpapers}
    '';
    desktop = makeDesktopItem {
      desktopName = "Swayimg-wallpapers";
      name = "swim-wp";
      exec = "${swim-wp}/bin/swim-wp";
      categories = [ "Graphics" "Viewer" ];
      icon = "swayimg";
    };
    wallpapers = linkFarm "wallhaven-collection"
      (lib.forEach
        (lib.importJSON ./wallhaven-collection.json)
        (data:
          let path = fetchurl data; in { inherit path; inherit (path) name; }));
  in
  symlinkJoin {
    name = "swayimg";
    paths = [ swayimg swim-wp desktop ];
    postBuild = "ln -s $out/bin/swayimg $out/bin/swim";
  };

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

}
