{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
{
  services.logind.extraConfig = ''
    IdleAction=suspend
    IdleActionSec=10min
  '';
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
  programs.fish.enable = true;
  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
    users.${vars.users.master.name} = {
      hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
      ];
    };
  };
}
