{ config, pkgs, inputs, ... }: with pkgs;
let
  vimproved = stdenv.mkDerivation {
    name = "interception-vimproved";
    src = inputs.interception-vimproved;
    doCheck = false;
    makeFlags = [ "INSTALL_FILE=$(out)/opt/interception/interception-vimproved" ];
  };
  additionalKeys = writeText "interception-additional-device" (builtins.toJSON {
    NAME = "Extra Buttons";
    EVENTS.EV_KEY = [ "KEY_MICMUTE" "KEY_BRIGHTNESSDOWN" "KEY_BRIGHTNESSUP" ];
  });
  dfk =
    let
      genVal = { k, t, h }: {
        KEY = k;
        TAP = t;
        HOLD = h;
        HOLD_START = "BEFORE_CONSUME_OR_RELEASE";
      };
    in
    writeText "interception-dfk" (builtins.toJSON {
      MAPPINGS =
        [
          (genVal { k = "KEY_CAPSLOCK"; t = "KEY_ESC"; h = "KEY_LEFTCTRL"; })
          (genVal rec { k = "KEY_ENTER"; t = k; h = "KEY_LEFTALT"; })
          (genVal rec { k = "KEY_LEFTALT"; t = "KEY_LEFTMETA"; h = t; })
          (genVal rec { k = "KEY_LEFTMETA"; t = "KEY_LEFTALT"; h = t; })
          (genVal rec { k = "KEY_RIGHTCTRL"; t = "KEY_RIGHTMETA"; h = t; })
          (genVal rec { k = "KEY_RIGHTSHIFT"; t = "KEY_RIGHTCTRL"; h = k; })
          (genVal rec { k = "KEY_RIGHTALT"; t = "KEY_KATAKANAHIRAGANA"; h = k; })
        ];
    });
in
{
  services.interception-tools = {
    enable = true;
    plugins = [ interception-tools-plugins.dual-function-keys vimproved ];
    udevmonConfig = builtins.toJSON [
      {
        JOB = "${interception-tools}/bin/intercept -g /dev/input/by-path/platform-i8042-serio-0-event-kbd |
        ${interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dfk} |
        ${vimproved}/opt/interception/interception-vimproved |
        ${interception-tools}/bin/uinput -d /dev/input/by-path/platform-i8042-serio-0-event-kbd -c ${additionalKeys}";
        DEVICE.EVENTS.EV_KEY = [ "KEY_KATAKANAHIRAGANA" ];
      }
    ];
  };
}
