{
  programs = {
    bash = {
      enable = true;
      historySize = -1;
      historyFileSize = -1;
      historyControl = [
        "ignorespace"
        "erasedups"
      ];
      initExtra = ''
        if [[ "$(declare -p PROMPT_COMMAND 2>&1)" == "declare -a"* ]]; then
          PROMPT_COMMAND=('history -a' "''${PROMPT_COMMAND[@]}")
        else
          PROMPT_COMMAND="history -a''${PROMPT_COMMAND:+;''$PROMPT_COMMAND}"
        fi
      '';
    };
    readline = {
      enable = true;
      variables = {
        colored-stats = true;
        completion-prefix-display-length = 1;
        completion-ignore-case = true;
        completion-query-items = 0; # just show me them
        # good complete behavior
        menu-complete-display-prefix = true;
        show-all-if-ambiguous = true;
        show-all-if-unmodified = true;
        skip-completed-text = true;
      };
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
        "\\C-i" = "menu-complete";
        "\\C-n" = "menu-complete";
        "\\e[Z" = "menu-complete-backward";
        "\\C-p" = "menu-complete-backward";
      };
    };
  };
}
