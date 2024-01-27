{ lib, ... }:

{
  options = {
    host-specs = with lib; {
      device-type = mkOption {
        type = types.nullOr (types.enum [ "laptop" "desktop" "server" "phone" ]);
        default = null;
      };

      output-name = mkOption {
        type = types.str;
        default = null;
        description = "`output_name` to configure `xdg-desktop-portal-wlr`";
      };

      cores = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      ram = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      wifi = mkOption {
        type = types.bool;
        default = false;
      };

      bluetooth = mkOption {
        type = types.bool;
        default = false;
      };

      battery = mkOption {
        type = types.bool;
        default = false;
      };

      webcam = mkOption {
        type = types.bool;
        default = false;
      };

      als = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
