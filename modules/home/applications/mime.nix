{ config, lib, ... }: {
  xdg.mime.defaultApplications = {
    "application/pdf" = "sioyek.desktop";
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
  };
  environment = {
    # TODO fix conflict between https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/programs/environment.nix#L25
    # and https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/config/shells-environment.nix#L172
    sessionVariables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
    variables.XDG_CONFIG_DIRS =
      lib.mkForce config.environment.sessionVariables.XDG_CONFIG_DIRS;
  };
}
