{ inputs, prev }:
let
  inherit (prev) system lib;

  neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim.overrideAttrs (old: {
    # TODO remove me
    patches = builtins.filter
      (p:
        (if builtins.typeOf p == "set" then baseNameOf p.name else baseNameOf) != "use-the-correct-replacement-args-for-gsub-directive.patch")
      old.patches;
  });
  #neovim-unwrapped = inputs.nvim-nightly.packages.${system}.neovim;
in
{
  inherit neovim-unwrapped;

  nvim = with prev;
    let
      init = "${inputs.nvim}/init.lua";
      runtime = "${inputs.nvim}";
      deno-with-webkitgtk = symlinkJoin {
        name = "deno-with-webkitgtk";
        paths = [ deno ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild =
          let libPath = lib.makeLibraryPath ([ gcc-unwrapped glib gtk3 webkitgtk ]);
          in "wrapProgram $out/bin/deno --prefix LD_LIBRARY_PATH : ${libPath}";
      };

      binPath = lib.makeBinPath [
        gnumake
        gcc

        # lsp
        nil
        nodePackages.bash-language-server
        sumneko-lua-language-server

        # fmt
        nixpkgs-fmt
        shfmt
        deno-with-webkitgtk

        # diagnostics
        shellcheck
        (callPackage ../pkgs/languagetool-rust.nix { })
      ];

      binPathExtra = lib.makeBinPath [
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
    {
      mini = wrapNeovimUnstable neovim-unwrapped (cfg binPath);
      full = wrapNeovimUnstable neovim-unwrapped (cfg binPathWithExtra);
    };
}
