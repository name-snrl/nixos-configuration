{ config, pkgs, ... }: {
  programs.bash.interactiveShellInit = ''
    # hist
    HISTCONTROL="ignorespace:erasedups";
    HISTFILESIZE="-1";
    HISTSIZE="-1";
    PROMPT_COMMAND="history -a";

    stty -ixon # disable flow control
    bind "set completion-ignore-case on"
    eval "$(zoxide init --cmd j bash)"

    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias usrcfg
    complete -F _complete_alias nboot
    complete -F _complete_alias nswitch
    complete -F _complete_alias nupdate
    complete -F _complete_alias nclear
    complete -F _complete_alias sctl
  '';
}
