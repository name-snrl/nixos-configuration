{ lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$nix_shell"

        "$line_break"
        "$time"
        "$shell"
        "$jobs"
        "$cmd_duration"
        "$character"
      ];

      username = {
        style_user = "bold blue";
        show_always = true;
      };

      hostname.format = "[$hostname](bold green) in ";

      directory = {
        style = "cyan";
        truncation_length = 6;
        truncate_to_repo = false;
        read_only = " [RO]";
        truncation_symbol = ".../";
        repo_root_style = "italic yellow";
      };

      git_branch = {
        style = "bold yellow";
        only_attached = true;
      };

      git_commit.format = "on [ $hash](bold yellow) ";

      git_state.style = "bold red";

      nix_shell = {
        format = "inside [$state $name](bold purple) ";
        heuristic = true;
        unknown_msg = "nix shell";
      };

      time = {
        format = "[$time](bold yellow) ";
        disabled = false;
      };

      shell = {
        style = "bold white italic";
        bash_indicator = "bash";
        fish_indicator = "fish";
        nu_indicator = "nushell";
        disabled = false;
      };

      jobs.format = "[+$number](cyan) ";

      cmd_duration.format = "[$duration](yellow) ";

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
      };

      continuation_prompt = "[-](bold yellow) ";
    };
  };
}
