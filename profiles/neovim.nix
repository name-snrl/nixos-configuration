{ config, pkgs, inputs, ... }:

with pkgs;

let
  runtime = "${inputs.nvim}";

  init = "${inputs.nvim}/init.lua";

  pager_init = "${inputs.nvim}/pager_init.lua";

  nvim =
    let
      res = neovimUtils.makeNeovimConfig {
        vimAlias = true;
        viAlias = true;
      };
      cfg = res // {
        wrapRc = false;
        wrapperArgs = res.wrapperArgs ++ [
          "--add-flags"
          "--cmd 'set rtp+=${runtime}' -u ${init}"
        ];
      };
    in
    wrapNeovimUnstable neovim-unwrapped cfg;
in

{ environment.systemPackages = [ nvim ]; }
