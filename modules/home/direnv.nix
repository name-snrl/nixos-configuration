{ config, pkgs, ... }: with pkgs; {
  programs.fish.interactiveShellInit = "${direnv}/bin/direnv hook fish | source";
  environment.systemPackages = [ direnv ];
  systemd.user.tmpfiles.rules = [
    "f+ %h/.config/direnv/direnvrc - - - - source ${nix-direnv.override { nix = config.nix.package; }}/share/nix-direnv/direnvrc"
  ];
}
