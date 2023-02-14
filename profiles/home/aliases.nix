{ config, pkgs, ... }:
let
  cfgPath = "~/nixos-configuration";
  host = config.networking.hostName;
in
{
  environment.shellAliases = {
    se = "sudoedit";
    pg = "$PAGER";
    ls = "exa";
    rg = "rg --follow --hidden --smart-case --no-messages";
    fd = "fd --follow --hidden";
    dt = "difft";
    tk = "tokei";
    cat = "bat --pager=never --style=changes,rule,numbers,snip";
    sctl = "systemctl";
    sudo = "sudo "; # this will make sudo work with shell aliases/man alias
    reboot = "echo 'Are you sure?'; read && systemctl reboot";
    usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";

    # use extended regex instead of BRE
    grep = "grep -E";
    sed = "sed -E";

    # NixOS
    jnp = "cd ${pkgs.path}";
    nboot = "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}#${host}";
    nswitch = "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}#${host}";
    nbuild = "nix build --no-link ${cfgPath}#${host}";
    nupdate = "nix flake update --commit-lock-file ${cfgPath}";
    nlock = "nix flake lock --commit-lock-file ${cfgPath}";
    nclear = "sudo nix-collect-garbage --delete-old";
  };
}
