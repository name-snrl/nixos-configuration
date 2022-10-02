{ config, pkgs, inputs, lib, ... }:

with pkgs;

let
  runtime = "${inputs.nvim}";

  init = "${inputs.nvim}/init.lua";

  binPath = lib.makeBinPath [
    gnumake
    gcc

    ltex-ls
    rnix-lsp
    shellcheck
    python310Packages.python-lsp-server
    nodePackages.bash-language-server
    sumneko-lua-language-server
  ];

  nvim =
    let
      res = neovimUtils.makeNeovimConfig {
        withRuby = false;
        vimAlias = true;
        viAlias = true;
      };
      cfg = res // {
        wrapRc = false;
        wrapperArgs = res.wrapperArgs ++ [
          "--add-flags"
          "--cmd 'set rtp+=${runtime}' -u ${init}"
          "--suffix" "PATH" ":" binPath
        ];
      };
    in
    wrapNeovimUnstable neovim-unwrapped cfg;
in

{ environment.systemPackages = [ nvim ]; }
