{ inputs, prev }:
let
  inherit (prev) system lib;

  neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim;
in
{
  inherit neovim-unwrapped;

  nvimpager = (inputs.nvimpager.packages.${system}.default.overrideAttrs (_: {
    doCheck = false;
    postInstall = ''
      mv $out/bin/nvimpager $out/bin/less
      sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
      sed -i 's#/bin/nvim#& -u ${inputs.nvim}/pager_init.lua#' $out/bin/less
    '';
  })).override { neovim = neovim-unwrapped; };

  nvim = with prev;
    let
      init = "${inputs.nvim}/init.lua";
      runtime = "${inputs.nvim}";

      binPath = lib.makeBinPath [
        gnumake
        gcc

        nil
        nixpkgs-fmt
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
        metals
        scalafmt
      ];

      binPathWithExtra = builtins.concatStringsSep ":" [ binPath binPathExtra ];

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
      full = wrapNeovimUnstable neovim-unwrapped (cfg binPathWithExtra);
    };
}
