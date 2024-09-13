{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      difftastic
      gojq
      ripgrep
      fd
      eza
      file
      tree
      wget
      rsync
      scripts.sf
      cloc
      just

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
