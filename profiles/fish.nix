{ config, pkgs, ... }: {
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    shellAliases = {
      j = "ji"; # `--cmd j` broken :(
      stwork = "openvpn3 session-start --config ~/.openvpn/tawasal_eu1.ovpn; ${pkgs.hubstaff}/bin/HubstaffClient & disown; exit";
      spwork = "openvpn3 session-manage -D --config ~/.openvpn/tawasal_eu1.ovpn";
      reboot = "read -P 'Are you sure? ' yn; [ $yn = y ] && systemctl reboot";
    };
    shellAbbrs = {
      nshell  = "nix shell self#";
      nbuild  = "nix build self#";
      nrun    = "nix run self#";
      nsearch = "nix search self#";
      nedit   = "nix edit self#";
    };
    interactiveShellInit = with pkgs; ''

      # TODO
      function git
        SHELL=${bash}/bin/bash ${git}/bin/git $argv
      end
      # fzf-complete
      # autopairs

      stty -ixon # disable flow control
      set -U fish_greeting
      ${coreutils}/bin/dircolors -c | source
      ${zoxide}/bin/zoxide init --cmd ji fish | source

      function nwhich
        readlink -f $(which $argv)
      end

      function njump
        cd $(string split -f1-4 / $(readlink -f $(which $argv)) | string join /)
      end

      complete -c nwhere -n __fish_complete_command
      complete -c njump -n __fish_complete_command
    '';
  };
}
