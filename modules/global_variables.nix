{ config, lib, ... }:
with lib;
with types; {
  options = {
    userName = mkOption {
      type = str;
      default = "name_snrl";
      example = "your_name";
      description = ''
        Just stores the username.
      '';
    };
  };
}
