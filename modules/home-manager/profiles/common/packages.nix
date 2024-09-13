{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      difftastic
      ripgrep
      fd
      eza
      file
      tree
      cloc
      just
      curl
      wget
      rsync

      # networking
      tcpdump # tcpdump -i wireCat port 67 or port 68 -n -vv
      nmap
      traceroute
      mtr
    ];
    sessionVariables = {
      DFT_DISPLAY = "inline"; # difftastic mode
    };
  };
}
