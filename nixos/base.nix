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
    users.root.imports =
      with lib.fileset;
      let
        drop = lib.flip difference;
        listNixFiles = u: toList (intersection (fileFilter (f: f.hasExt "nix") ../.) u);
      in
      lib.pipe ../home-manager/snrl/base [
        (drop ../home-manager/snrl/base/shell/direnv.nix)
        (drop ../home-manager/snrl/base/git.nix)
        (drop ../home-manager/snrl/base/home-manager.nix)
        (drop ../home-manager/snrl/base/stylua.nix)
        (drop ../home-manager/snrl/base/taskwarriror.nix)
        (drop ../home-manager/snrl/base/configuration-management.nix)

        listNixFiles
      ];
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
  environment.variables.EDITOR = lib.mkOverride 900 null;
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
