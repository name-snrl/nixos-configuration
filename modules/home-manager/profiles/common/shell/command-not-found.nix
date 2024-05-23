{ pkgs, ... }:
{
  programs = {
    nix-index = {
      enable = true;
      package = pkgs.nix-index-with-db;
    };
    command-not-found.enable = false;
  };
}
