{ config, pkgs, inputs, ... }: {
  environment.etc."interception-tools.yaml".text = ''
    MAPPINGS:
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_ENTER
        TAP: KEY_ENTER
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_LEFTALT
        TAP: KEY_LEFTMETA
        HOLD: KEY_LEFTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_LEFTMETA
        TAP: KEY_LEFTALT
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_RIGHTCTRL
        TAP: KEY_RIGHTMETA
        HOLD: KEY_RIGHTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_RIGHTSHIFT
        TAP: KEY_RIGHTCTRL
        HOLD: KEY_RIGHTSHIFT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE
  '';

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | \
      ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/interception-tools.yaml | \
      ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ENTER, KEY_LEFTALT, KEY_LEFTMETA, KEY_RIGHTCTRL, KEY_SPACE, KEY_LEFTSHIFT, KEY_RIGHTSHIFT]
    '';
  };

  console.useXkbConfig = true;
  services.xserver.layout = "lv3_us";
  services.xserver.xkbOptions = "lv3:ralt_switch";
  services.xserver.extraLayouts.lv3_us = {
    description = "US layout with lvl3";
    languages = [ "eng" ];
    symbolsFile = "${inputs.dots}/.config/xkb/symbols/lv3_us";
  };
}
