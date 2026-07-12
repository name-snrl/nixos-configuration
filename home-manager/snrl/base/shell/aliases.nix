{
  lib,
  osConfig,
  ...
}:
let
  isModule = osConfig != null;
in
{
  home.shellAliases = {
    jnp = lib.mkIf isModule "cd ${osConfig.nixpkgs.flake.source}";

    ls = "eza --group-directories-first --group --git";
    rg = "rg --follow --hidden --glob=!.git --smart-case --no-messages";
    fd = "fd --follow --hidden";
    dt = "difft";
    cl = "cloc";
    tree = "tree -C";
    sctl = "systemctl";
    reboot = "echo 'Are you sure?'; read && systemctl reboot";
  };
}
