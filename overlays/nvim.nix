inputs: final: prev: {
  nvim =
    let
      init = "${inputs.nvim}/init.lua";
      runtime = "${inputs.nvim}";
      deno-with-webkitgtk = with prev; symlinkJoin {
        name = "deno-with-webkitgtk";
        paths = [ deno ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild =
          let libPath = lib.makeLibraryPath ([ gcc-unwrapped glib gtk3 webkitgtk ]);
          in "wrapProgram $out/bin/deno --prefix LD_LIBRARY_PATH : ${libPath}";
      };

      binPath = with prev; lib.makeBinPath [
        gnumake
        gcc

        # lsp
        nil
        nodePackages.bash-language-server
        sumneko-lua-language-server

        # fmt
        nixpkgs-fmt
        shfmt
        stylua
        deno-with-webkitgtk

        # diagnostics
        shellcheck
        languagetool-rust
      ];

      binPathExtra = with prev; lib.makeBinPath [
        metals
        scalafmt
      ];

      binPathWithExtra = builtins.concatStringsSep ":" [ binPath binPathExtra ];

      cfg = path:
        let
          res = prev.neovimUtils.makeNeovimConfig {
            withRuby = false;
            vimAlias = true;
            viAlias = true;
            plugins = [ ];
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
    with prev; {
      mini = wrapNeovimUnstable neovim-unwrapped (cfg binPath);
      full = wrapNeovimUnstable neovim-unwrapped (cfg binPathWithExtra);
    };
}
