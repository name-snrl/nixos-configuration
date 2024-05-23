/**
  I don't care about ls, but not tree

  TODO
  - create module for home-manager
*/
{ pkgs, ... }:
{
  programs = with pkgs; {
    bash.initExtra = ''
      export LS_COLORS="''$(${vivid}/bin/vivid generate one-dark)"
    '';
    fish.interactiveShellInit = ''
      set -gx LS_COLORS (${vivid}/bin/vivid generate one-dark)
    '';
  };
}
