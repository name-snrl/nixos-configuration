{ config, pkgs, ... }:
let
  complete = pkgs.fetchFromGitHub {
    owner = "lincheney";
    repo = "fzf-tab-completion";
    rev = "3dfaca917cd862f6f1299f1be47a30d19303258b";
    sha256 = "UOyuPpSdReNj3GC5FnQkhB/OlV7oIXKRChDtAciQqKs=";
  };
in
{
  programs.bash.interactiveShellInit = ''
    # hist
    HISTCONTROL=ignorespace:erasedups
    HISTFILESIZE=-1
    HISTSIZE=-1
    PROMPT_COMMAND="history -a"

    # options
    bind "set completion-ignore-case on"

    # mapping
    stty -ixon # disable flow control
    stty werase ^- # unbind C-w in tty
    bind '"\C-w": backward-kill-word'
    bind '"\er": redraw-current-line'
    bind '"\C-g": "$(_gh)\e\C-e\er"'
    bind -x '"\C-r": __fzf_history__'
    bind -x '"\C-p": fzf_bash_completion'
    bind -x '"\C-n": fzf_bash_completion'

    ### extensions
    eval "$(zoxide init --cmd j bash)"

    # alias completion
    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias usrcfg
    complete -F _complete_alias nboot
    complete -F _complete_alias nswitch
    complete -F _complete_alias nupdate
    complete -F _complete_alias nclear
    complete -F _complete_alias sctl

    # fzf git hash
    is_in_git_repo() {
        git rev-parse --git-dir &> /dev/null
    }

    _gh() {
        is_in_git_repo || return
        git log --format="%C(blue)%C(bold)%cd %C(auto)%h%d %s (%an)" --date=short \
            --graph --color=always |
        fzf --height 50% --min-height 20 --ansi --no-sort --reverse --multi \
            --preview-window border-left \
            --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
        cut -d- -f2- | awk '{print $2}'
    }

    # fzf search history (C-r)
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:5:border-top:wrap"

    __fzfcmd() {
        [[ -n "$TMUX_PANE" ]] && { [[ "''${FZF_TMUX:-0}" != 0 ]] || [[ -n "$FZF_TMUX_OPTS" ]]; } &&
            echo "fzf-tmux ''${FZF_TMUX_OPTS:--d''${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
    }

    __fzf_history__() {
        local output opts script
        opts="--height ''${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS \
            -n2..,.. --tiebreak=index --min-height 15 $FZF_CTRL_R_OPTS +m --read0"
        script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; \
            print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
        output=$(
            builtin fc -lnr -2147483648 |
                last_hist=$(HISTTIMEFORMAT="" builtin history 1) \
                /run/current-system/sw/bin/perl -n -l0 -e "$script" |
                FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) --query "$READLINE_LINE"
        ) || return
        READLINE_LINE=''${output#*$'\t'}
        if [[ -z "$READLINE_POINT" ]]; then
            echo "$READLINE_LINE"
        else
            READLINE_POINT=0x7fffffff
        fi
    }

    # fzf completion
  '' + builtins.readFile (complete + /bash/fzf-bash-completion.sh);
}
