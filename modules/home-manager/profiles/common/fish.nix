{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [ { inherit (pkgs.fishPlugins.autopair) src name; } ];
    interactiveShellInit =
      with pkgs; # fish
      ''
        stty -ixon # disable flow control
        set -U fish_greeting # disable greeting
        # TODO use programs.dircolors.enable instead
        ${coreutils}/bin/dircolors -c | source

        # Globbing exclusion functional
        function exclude
            argparse a/all -- $argv || return
            set cmd '${fd}/bin/fd --max-depth 1 --glob'
            if set -ql _flag_a
                set cmd "$cmd --hidden --no-ignore"
            end
            for path in $argv
                set cmd "$cmd --exclude '$path'"
            end
            eval $cmd
        end

        # Nix tricks
        function njump;   cd $(string split -f1-4 / (nwhich $argv) | string join /); end
        function nwhich;  ${coreutils}/bin/readlink -f (${which}/bin/which $argv); end
        complete -c njump   -fa "(__fish_complete_command)"
        complete -c nwhich  -fa "(__fish_complete_command)"

        # colors
        set fish_pager_color_prefix cyan --bold

        function fish_prompt
            set -l last_pipestatus $pipestatus
            set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

            set -l usr
            if functions -q fish_is_root_user; and fish_is_root_user
                set usr "$(set_color --bold red)$USER$(set_color normal)"
            else
                set usr "$(set_color --bold blue)$USER$(set_color normal)"
            end

            set -l host
            if set -q SSH_TTY
                or begin
                    command -sq systemd-detect-virt
                    and systemd-detect-virt -q
                end
                set host " at $(set_color --bold green)$(prompt_hostname)$(set_color normal)"
            end

            set -l pwd " in $(set_color --bold cyan)$(prompt_pwd --dir-length 0)$(set_color normal)"

            set -l branch (fish_vcs_prompt)
            if test -n "$branch"
                set branch " $(set_color --bold yellow)$branch$(set_color normal)"
            end

            set -l nix_shell
            if string match -r /nix/store "$PATH" &>/dev/null
                set nix_shell " inside $(set_color --bold magenta)nix shell$(set_color normal)"
            end

            set -l duration (math floor $CMD_DURATION / 1000)
            if test $duration -gt 10
                if test $duration -ge 86400
                    set duration (math floor $duration / 86400)d(math floor $duration / 3600 % 24)h(math floor $duration / 60 % 60)m(math $duration % 60)s
                else if test $duration -ge 3600
                    set duration (math floor $duration / 3600 % 24)h(math floor $duration / 60 % 60)m(math $duration % 60)s
                else if test $duration -ge 60
                    set duration (math floor $duration / 60 % 60)m(math $duration % 60)s
                else
                    set duration (math $duration % 60)s
                end
                set duration " took $(set_color --bold yellow)$duration$(set_color normal)"
            else
                set -e duration
            end

            set -l cmd_status (__fish_print_pipestatus "[" "]" "|" (set_color --bold red) (set_color --bold red) $last_pipestatus)
            if test -n "$cmd_status"
                set cmd_status "$cmd_status "
            end

            set -l num_jobs
            if jobs >/dev/null
                if test -n "$cmd_status"
                    set num_jobs "| $(set_color --bold green)bg $(count (jobs))$(set_color normal) "
                else
                    set num_jobs "$(set_color --bold green)bg $(count (jobs))$(set_color normal) "
                end
            end

            echo -ne "\n$usr$host$pwd$branch$nix_shell$duration\n$cmd_status$num_jobs> "
        end
      '';
  };
}
