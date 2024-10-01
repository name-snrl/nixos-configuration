{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.logind.extraConfig = ''
    IdleAction=suspend
    IdleActionSec=10min
  '';
  security = {
    sudo.enable = false;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.local &&
          subject.user == "${config.users.users.default.name}") {
          return polkit.Result.YES;
        }
      });
    '';
  };
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "sudo";
      runtimeInputs = [ config.systemd.package.out ];
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
    users.default = {
      name = "name_snrl";
      hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
      ];
    };
  };
}
