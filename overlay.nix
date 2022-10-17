inputs: final: prev:
let
  inherit (final) system;
in
{
  nur = import inputs.nur {
    nurpkgs = prev;
    pkgs = prev;
  };

  neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim;

  nvimpager = (inputs.nvimpager.overlay final prev).nvimpager.overrideAttrs (_: {
    postInstall = ''
      runHook preBuild

      mv $out/bin/nvimpager $out/bin/less
      sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
      sed -i 's#rc=.*#rc=${inputs.nvim}/pager_init.lua#' $out/bin/less

      runHook postBuild
    '';
  });

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

}
