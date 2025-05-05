{
  inputs,
  vars,
  lib,
  config,
  ...
}:
{
  home-manager.users.${vars.users.master.name}.imports =
    inputs.self.moduleTree.home-manager.profiles.snrl
      { };

  environment.persistence = lib.mkIf config.chaotic.zfs-impermanence-on-shutdown.enable {
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
