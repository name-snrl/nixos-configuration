{
  vars,
  lib,
  ...
}:
{
  home-manager.users.${vars.users.master.name}.imports =
    with lib.fileset;
    toList (fileFilter (f: f.hasExt "nix") ../../../../../home-manager/snrl);

  environment.persistence = {
    ${vars.fs.impermanence.persistent}.users.${vars.users.master.name} = {
      files = [
        ".bash_history"
      ];
      directories = lib.attrValues vars.users.master.dirs ++ [
        ".local/share/systemd"
        ".local/share/iwctl"

        ".config/nvim"
        ".local/state/nvim"
        ".local/share/nvim"
        ".cache/nvim"

        ".local/share/fish"
        ".local/share/zoxide"
        ".local/share/direnv"
        ".local/share/task"
        ".cache/tealdeer"

        ".mozilla"
        ".cache/mozilla"
        ".local/share/Anki2"
        ".local/share/fcitx5"
        ".local/share/KotatogramDesktop"
        ".local/share/qBittorrent"
        ".local/state/mpv"
      ];
    };
  };
}
