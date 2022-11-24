inputs: final: prev:

let
  inherit (final) system lib;

  renameBin = target: name:
    prev.runCommand "${target}-as-${name}" { } ''
      mkdir -p "$out/bin"
      ln -sfn "${lib.getExe prev.${target}}" "$out/bin/${name}"
    '';
in

{
  stable = import inputs.stable { localSystem = { inherit system; }; };
  scripts = import ./scripts.nix prev;

  gojq-as-jq = renameBin "gojq" "jq";
  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  alacritty-as-xterm = renameBin "alacritty" "xterm";

  exo2 = inputs.shlyupa.packages.${prev.system}.exo2;
  kotatogram-desktop-with-webkit =
    inputs.shlyupa.packages.${prev.system}.kotatogram-desktop-with-webkit;

  neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim;
  nvim = with prev;
    let
      init = "${inputs.nvim}/init.lua";
      runtime = "${inputs.nvim}";

      binPath = lib.makeBinPath [
        gnumake
        gcc

        rnix-lsp
        shellcheck
        python310Packages.python-lsp-server
        nodePackages.bash-language-server
        sumneko-lua-language-server
      ];

      binPathExtra = lib.makeBinPath [
        ltex-ls
        qutebrowser
        pandoc
      ];

      cfg = path:
        let
          res = neovimUtils.makeNeovimConfig {
            withRuby = false;
            vimAlias = true;
            viAlias = true;
          };
        in
        res // {
          wrapRc = false;
          wrapperArgs = res.wrapperArgs ++ [
            "--add-flags"
            "--cmd 'set rtp+=${runtime}' -u ${init}"
            "--suffix"
            "PATH"
            ":"
            path
          ];
        };
    in
    {
      mini = wrapNeovimUnstable neovim-unwrapped (cfg binPath);
      full = wrapNeovimUnstable neovim-unwrapped (cfg (builtins.concatStringsSep ":" [ binPath binPathExtra ]));
    };

  nvimpager = (inputs.nvimpager.overlay final prev).nvimpager.overrideAttrs (_: {
    postInstall = ''
      mv $out/bin/nvimpager $out/bin/less
      sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
      sed -i 's#rc=.*#rc=${inputs.nvim}/pager_init.lua#' $out/bin/less
    '';
  });

  # TODO create a pr to fix the pkg
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
