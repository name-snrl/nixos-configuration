{
  defaultUserName,
  config,
  pkgs,
  lib,
  ...
}:
{
  # This solution gives easy access to the primary user name, while leaving the
  # ability to define it in one place. Example:
  #
  # { users.users.foo = { isNormalUser = true; }; }
  #
  # You can then reference the username in another module/profile:
  #
  # { services.baz.username = config.users.users.foo.name; }
  #
  # But now, if you want to change the nickname, you'll have to do it in all
  # modules/profiles, because attrpath to username contains username itself.
  _module.args.defaultUserName = "name_snrl";

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
    users.${defaultUserName} = {
      hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
      ];
    };
  };
}
