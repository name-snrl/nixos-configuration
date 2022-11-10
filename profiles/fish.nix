{ config, pkgs, ... }: {
  users.defaultUserShell = pkgs.fish;
  environment.systemPackages = with pkgs; [ fishPlugins.autopair-fish ];
  programs.fish = {
    enable = true;
    shellAliases = {
      j = "ji"; # `--cmd j` broken :(
      stwork = "openvpn3 session-start --config ~/.openvpn/tawasal_eu1.ovpn; ${pkgs.hubstaff}/bin/HubstaffClient & disown; exit";
      spwork = "openvpn3 session-manage -D --config ~/.openvpn/tawasal_eu1.ovpn";
      reboot = "read -P 'Are you sure? ' yn; [ $yn = y ] && systemctl reboot";
    };
    interactiveShellInit = with pkgs; ''

      # TODO
      function git
        SHELL=${bash}/bin/bash ${git}/bin/git $argv
      end
      # fzf-complete
      # autopairs

      set -U fish_greeting
      stty -ixon # disable flow control
      ${coreutils}/bin/dircolors -c | source
      ${zoxide}/bin/zoxide init --cmd ji fish | source

      # Nix tricks
      function njump;   cd $(string split -f1-4 / (nwhich $argv) | string join /); end
      function nwhich;  ${coreutils}/bin/readlink -f (${which}/bin/which $argv); end
      function nshell;  ${nix}/bin/nix shell  $argv; end
      function nbuild;  ${nix}/bin/nix build  $argv; end
      function nsearch; ${nix}/bin/nix search $argv; end
      function nedit;   ${nix}/bin/nix edit   $argv; end
      function nrun;    ${nix}/bin/nix run    $argv; end

      complete -c njump   -fa "(__fish_complete_command)"
      complete -c nwhich  -fa "(__fish_complete_command)"
      complete -c nshell  -fa "(NIX_GET_COMPLETIONS=2 nix shell  self#)"
      complete -c nbuild  -fa "(NIX_GET_COMPLETIONS=2 nix build  self#)"
      complete -c nrun    -fa "(NIX_GET_COMPLETIONS=2 nix run    self#)"
      complete -c nsearch -fa "(NIX_GET_COMPLETIONS=2 nix search self#)"
      complete -c nedit   -fa "(NIX_GET_COMPLETIONS=2 nix edit   self#)"
    '';
  };
}
