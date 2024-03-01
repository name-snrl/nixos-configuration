{ config, lib, ... }:
{
  xdg.portal.wlr.settings.screencast = lib.mkIf (lib.isString config.host-specs.output-name) {
    output_name = config.host-specs.output-name;
    max_fps = 60;
    chooser_type = "none";
  };
}
