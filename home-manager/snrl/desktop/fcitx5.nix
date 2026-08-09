{
  i18n.inputMethod.fcitx5 = {
    quickPhrase = {
      afraid = "(ㆆ _ ㆆ)";
      cry = "(╥﹏╥)";
      gimme = "༼ つ ◕_◕ ༽つ";
      shruggie = "¯\\_(ツ)_/¯";
      ":hmm:" = "🤔";
      ":roll_eyes:" = "🙄";
      ":upside_down:" = "🙃";
    };
    settings = {
      globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = false;
          AltTriggerKeys = "";
          EnumerateBackwardKeys = "";
          EnumerateSkipFirst = true;
          EnumerateGroupForwardKeys = "";
          EnumerateGroupBackwardKeys = "";
        };

        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
          "1" = "Zenkaku_Hankaku";
          "2" = "Hangul";
        };

        "Hotkey/ActivateKeys" = {
          "0" = "Hangul_Hanja";
          "1" = "Super+space";
        };

        "Hotkey/EnumerateForwardKeys" = {
          "0" = "Super+space";
        };

        "Behavior/DisabledAddons" = {
          "0" = "clipboard";
          "1" = "emoji";
          "2" = "spell";
        };
      };

      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-ru";
        };

        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "keyboard-ru";
        "Groups/0/Items/2".Name = "mozc";

        GroupOrder = {
          "0" = "Default";
        };
      };

      addons = {
        classicui = {
          globalSection = {
            PreferTextIcon = true;
            Theme = "plasma";
            DarkTheme = "plasma";
            UseDarkTheme = true;
          };
        };

        imselector = {
          sections = {
            SwitchKey = {
              "0" = "VoidSymbol";
              "1" = "Super+F7";
              "2" = "Super+F8";
            };
          };
        };
      };
    };
  };
}
