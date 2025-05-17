{ lib, ... }:
{
  _module.args = {
    __findFile = _: s: ../../${s};
    # There are 2 reasons for using `vars`:
    #
    # - This helps avoid typos that could cause serious issues, e.g. creating
    #   persistent storage location in impermanence.
    # - This allows reusing information such as service names, ports, etc., across
    #   all modules.
    vars = {
      flake-ref = "github:name-snrl/nixos-configuration";

      users = {
        master = {
          name = "name_snrl";
          uid = 1000;
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

        gf = {
          name = "Elizabeth";
          uid = 1001;
        };
      };

      fs = {
        impermanence = {
          persistent = "/persistent";
          shared = "/shared";
        };
      };
    };
  };
}
