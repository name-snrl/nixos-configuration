{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.fish;
  environment.systemPackages = with pkgs.fishPlugins; [ autopair-fish ];
  programs.fish = {
    enable = true;
    interactiveShellInit = with pkgs; ''
      stty -ixon # disable flow control
      set -U fish_greeting # disable greeting
      ${coreutils}/bin/dircolors -c | source
      ${zoxide}/bin/zoxide init --cmd j fish | source

      # Globbing exclusion functional
      function exclude
          argparse a/all -- $argv || return
          set cmd '${fd}/bin/fd --max-depth 1 --glob'
          if set -ql _flag_a
              set cmd "$cmd -H"
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

      # https://github.com/fish-shell/fish-shell/issues/10296
      function fish_clipboard_paste
          commandline -i -- (${osc}/bin/osc paste)
      end
    '';
  };
}
