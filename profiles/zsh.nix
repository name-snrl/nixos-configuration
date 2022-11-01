{ config, pkgs, inputs, ... }: {
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    histSize = 999999;
    setOptions = [ "HIST_IGNORE_DUPS" "SHARE_HISTORY" "HIST_FCNTL_LOCK" ];
    shellAliases = {
        reboot = "read '?Are you sure? ' i;[[ $i == y ]] && reboot";
    };
    interactiveShellInit = with pkgs;
      ''
        #source ${grml-zsh-config}/etc/zsh/zshrc

        #prompt off
        stty -ixon # disable flow control

        # hist
        #HISTCONTROL=ignorespace:erasedups
        #HISTFILESIZE=-1
        #HISTSIZE=-1
        #PROMPT_COMMAND="history -a"

        # nix stuff
        #complete -c nwhere;
        nwhere() {
          readlink -f "$(which "$@")"
        }

        #complete -c njump
        njump() {
          cd "$(readlink -f "$(which "$@")" | cut -d/ -f-4)"
        }

        eval "$(zoxide init --cmd j zsh)"
        eval "$(${coreutils}/bin/dircolors -b)"
        source ${fzf}/share/fzf/key-bindings.zsh # remove other binds
        source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source ${inputs.zsh-system-clipboard}/zsh-system-clipboard.zsh # works only in visual/vi mode
        source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh; autopair-init
      '' + builtins.replaceStrings [ "green" ] [ "blue" ]
        (builtins.readFile "${inputs.fzf-git}/fzf-git.sh") + ''
        _fzf_git_fzf() {
          fzf-tmux -p80%,60% -- \
            --layout=reverse --multi --height=50% --min-height=20 \
            --color='header:italic:underline' \
            --preview-window='right,50%,border-left' \
            --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
        }
      '';
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true; # looks very bad
  };
}
