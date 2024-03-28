{ config, pkgs, ... }:
let
  cfgPath = "~/nixos-configuration";
in
{
  environment.shellAliases = {
    ip = "ip --color=auto";
    pg = "$PAGER";
    ls = "eza --group-directories-first";
    rg = "rg --follow --glob=!.git --hidden --smart-case --no-messages";
    fd = "fd --follow --hidden";
    dt = "difft";
    cl = "cloc";
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
    nboot = "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}";
    nswitch = "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}";
    nbuild = "nix build --no-link ${cfgPath}#${config.networking.hostName}";
    nupdate = "nix flake update --commit-lock-file ${cfgPath}";
    # TODO with nix 2.19, nlock is no longer needed to update inputs
    nlock = "nix flake lock --commit-lock-file ${cfgPath}";
    # https://github.com/NixOS/nix/issues/8508
    nclear = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
  };
}
