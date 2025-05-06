{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [ { inherit (pkgs.fishPlugins.autopair) src name; } ];
    interactiveShellInit =
      with pkgs; # fish
      ''
        stty -ixon # disable flow control
        set -g fish_greeting # disable greeting

        bind ctrl-c cancel-commandline

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
        set -U fish_pager_color_prefix cyan --bold
        # make blue great again
        # https://github.com/fish-shell/fish-shell/pull/10758
        set -U fish_color_command blue
        set -U fish_color_keyword blue
      '';
  };
}
