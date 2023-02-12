{ config, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      # Base
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
      };
      continuation_prompt = "[-](bold yellow) ";

      username = {
        style_user = "bold blue";
        show_always = true;
      };

      directory = {
        truncation_length = 6;
        truncate_to_repo = false;
        read_only = " [RO]";
        truncation_symbol = "../";
        repo_root_style = "bold yellow";
        home_symbol = "~";
      };

      jobs = {
        number_threshold = 1;
        format = "[$symbol $number]($style) ";
        symbol = "bg";
        style = "bold purple";
      };

      nix_shell = {
        format = "via [$state$symbol-$name]($style) ";
        symbol = " nix";
        style = "bold cyan";
      };
    } // builtins.listToAttrs (map (name: { inherit name; value.disabled = true; }) [
      #"username" "hostname" "directory"
      #"git_branch" "git_commit"
      #"git_metrics" "git_state"
      "git_status"
      #"hg_branch" "cmd_duration"
      #"line_break"
      #"jobs" "nix_shell" "character"

      # Sys or builtin
      "battery"
      "time"
      "status"
      "shell"
      "localip"
      "shlvl"
      "vcsh"
      "memory_usage"

      "singularity"
      "kubernetes"
      "docker_context"
      "package"

      "buf"
      "c"
      "cmake"
      "cobol"
      "container"
      "dart"
      "deno"
      "dotnet"
      "elixir"
      "elm"
      "erlang"
      "golang"
      "haskell"
      "helm"
      "java"
      "julia"
      "kotlin"
      "lua"
      "nim"
      "nodejs"
      "ocaml"
      "perl"
      "php"
      "pulumi"
      "purescript"
      "python"
      "rlang"
      "red"
      "ruby"
      "rust"
      "scala"
      "swift"
      "terraform"
      "vlang"
      "vagrant"
      "zig"
      "conda"
      "spack"
      "gcloud"
      "openstack"
      "crystal"
      "env_var"
      "sudo"

      "aws"
      "azure"
      #"daml"
    ]);
  };
}
