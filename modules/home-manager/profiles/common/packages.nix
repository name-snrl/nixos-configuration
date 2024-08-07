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
      scripts.sf
      cloc
      just
    ];
    sessionVariables = {
      DFT_DISPLAY = "inline"; # difftastic mode
    };
  };
}
