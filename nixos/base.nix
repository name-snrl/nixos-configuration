{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # configure root with home-manager shared modules
    users.root = { };
  };

  nix.channel.enable = false;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.self.overlays.composite ];
  };

  # necessary for programs that search for man pages
  documentation.man.cache.enable = true;

  # clear out the junk
  programs.nano.enable = false;
  environment.defaultPackages = lib.mkDefault [ ];

  programs.fish.enable = true;
  users = {
    defaultUserShell = config.programs.fish.package;
    mutableUsers = false;
  };

  security = {
    sudo.enable = false;
    # TODO seems this should be in upstream
    # https://github.com/NixOS/nixpkgs/issues/361592
    pam.services.systemd-run0 = { };
  };
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "sudo";
      runtimeInputs = [ config.systemd.package ];
      text = ''exec run0 ${
        lib.concatMapStringsSep " " (var: "--setenv=${var}") [
          "PATH"
          "SHELL"
          "LOCALE_ARCHIVE"
          "TZDIR"
          "NIX_PATH"
          "EDITOR"
          "PAGER"
          "MANPAGER"
          "LESS"
          "LESSKEYIN_SYSTEM"
          "LESSOPEN"
          "SYSTEMD_LESS"
        ]
      } "$@"'';
    })
  ];
}
