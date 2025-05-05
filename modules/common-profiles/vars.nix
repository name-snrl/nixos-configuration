# There are 2 reasons for using `vars`:
#
# - This helps avoid typos that could cause serious issues, e.g. creating
#   persistent storage location in impermanence.
# - This allows reusing information such as service names, ports, etc., across
#   all modules.
{ lib, ... }:
{
  _module.args.vars = {
    flake-ref = "github:name-snrl/nixos-configuration";

    users = {
      master = {
        name = "name_snrl";
        dirs =
          with lib;
          genAttrs [
            "desktop"
            "downloads"
            "experiments"
            "projects"
            "forks"
          ] id;
      };

      gf.name = "Elizabeth";
    };

    fs = {
      impermanence = {
        persistent = "/persistent";
        shared = "/shared";
      };
    };
  };
}
