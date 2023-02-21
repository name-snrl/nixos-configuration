{ inputs, final, prev }:
let
  inherit (final) system lib;
in
{
  neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim.overrideAttrs (old: {
    # TODO Remove once neovim 0.9.0 is released.
    patches = builtins.filter
      (p:
        (if builtins.typeOf p == "set" then baseNameOf p.name else baseNameOf) != "neovim-build-make-generated-source-files-reproducible.patch")
      old.patches;
  });

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
        # TODO create issue in markdown-preview.nvim.
        # with `-P` option firefox doesn't load page
        (writeShellScriptBin "firefox-md-preview" ''
          ${firefox-wayland}/bin/firefox -P firefox-md-preview \
          --name firefox-md-preview \
          --private-window "$@"
        '')
        ltex-ls
      ];

      cfg = path:
        let
          res = neovimUtils.makeNeovimConfig {
            withRuby = false;
            vimAlias = true;
            viAlias = true;
            plugins = [
              {
                plugin = vimPlugins.markdown-preview-nvim;
                config = null;
                optional = false;
              }
            ];
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
      full = wrapNeovimUnstable neovim-unwrapped (cfg
        (builtins.concatStringsSep ":" [ binPath binPathExtra ]));
    };

  nvimpager = (inputs.nvimpager.overlays.default final prev).nvimpager.overrideAttrs (_: {
    postInstall = ''
      mv $out/bin/nvimpager $out/bin/less
      sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
      sed -i 's#rc=.*#rc=${inputs.nvim}/pager_init.lua#' $out/bin/less
    '';
  });
}
