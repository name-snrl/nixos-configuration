inputs: final: prev: {

  inherit (inputs.shlyupa.packages.${final.system})
    kotatogram-desktop-with-webkit
    ;

  inherit (inputs.nix-index-db.packages.${final.system})
    nix-index-with-db
    ;

  neovim-unwrapped = inputs.nvim-nightly.packages.${final.system}.neovim;

  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (oa: {
    patches = [
      (final.fetchpatch {
        url = "https://github.com/emersion/xdg-desktop-portal-wlr/pull/282.patch";
        hash = "sha256-vRbGwF+ZAlL2kUnv/L93LuuOjTbPrdVJBKPRvYXjaBM=";
      })
    ];
  });

  foot = prev.foot.overrideAttrs (oa: {
    patches = [
      (final.fetchpatch {
        url = "https://codeberg.org/dnkl/foot/pulls/1099.patch";
        hash = "sha256-4B+PanJqBC3hANgSYXwXeGO19EBdVMyyIgGawpaIMxE=";
      })
    ];
    mesonFlags = oa.mesonFlags ++ [ "-Dext-underline=enabled" ];
  });

  xdragon = with final; let
    dg = writeShellApplication {
      name = "dg";
      runtimeInputs = [ prev.xdragon ];
      text = ''dragon -T "$@" &>/dev/null &'';
    };
  in
  symlinkJoin { name = "xdragon"; paths = [ prev.xdragon dg ]; };

  page = with final; let
    less = writeShellApplication {
      name = "less";
      runtimeInputs = [ prev.page ncurses ];
      text = ''exec page -O "$(tput lines)" "$@"'';
    };
  in
  symlinkJoin { name = "page"; paths = [ prev.page less ]; };

  swayimg = with final; let
    swim-wp = writeShellScriptBin "swim-wp" ''
      exec ${prev.swayimg}/bin/swayimg --fullscreen ${wallpapers}
    '';
    desktop = makeDesktopItem {
      desktopName = "Swayimg-wallpapers";
      name = "swim-wp";
      exec = "${swim-wp}/bin/swim-wp";
      categories = [ "Graphics" "Viewer" ];
      icon = "swayimg";
    };
    wallpapers = lib.concatStringsSep " "
      (lib.forEach
        (lib.importJSON ./wallhaven-collection.json)
        (data: (fetchurl data)));
  in
  symlinkJoin {
    name = "swayimg";
    paths = [ prev.swayimg swim-wp desktop ];
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
