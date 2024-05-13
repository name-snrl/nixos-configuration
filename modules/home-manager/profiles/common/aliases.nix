{
  home.shellAliases = {
    ip = "ip --color=auto";
    pg = "$PAGER";
    ls = "eza --group-directories-first --group --git";
    rg = "rg --follow --hidden --glob=!.git --smart-case --no-messages";
    fd = "fd --follow --hidden";
    dt = "difft";
    cl = "cloc";
    cat = "bat --pager=never --style=changes,rule,numbers,snip";
    sctl = "systemctl";
    sudo = "sudo "; # this will make sudo work with shell aliases/man alias
    reboot = "echo 'Are you sure?'; read && systemctl reboot";

    # use extended regex instead of BRE
    grep = "grep -E";
    sed = "sed -E";

    # TODO remove me
    usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";
  };
}
