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
    ];
    sessionVariables = {
      DFT_DISPLAY = "inline"; # difftastic mode
    };
  };
}
