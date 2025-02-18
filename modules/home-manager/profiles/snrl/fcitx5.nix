{ pkgs, ... }:
{
  xdg.configFile = {
    "fcitx5/config".source = (pkgs.formats.ini { }).generate "fcitx5-config" {
      Hotkey = {
        EnumerateWithTriggerKeys = "False";
        AltTriggerKeys = "";
        EnumerateForwardKeys = "";
        EnumerateBackwardKeys = "";
        EnumerateSkipFirst = "False";
        EnumerateGroupForwardKeys = "";
        EnumerateGroupBackwardKeys = "";
        ActivateKeys = "";
        DeactivateKeys = "";
        PrevPage = "";
        NextPage = "";
        PrevCandidate = "";
        NextCandidate = "";
        TogglePreedit = "";
      };

      "Hotkey/TriggerKeys"."0" = "Super+space";

      Behavior = {
        ActiveByDefault = "False";
        resetStateWhenFocusIn = "No";
        ShareInputState = "No";
        PreeditEnabledByDefault = "True";
        ShowInputMethodInformation = "False";
        showInputMethodInformationWhenFocusIn = "False";
        CompactInputMethodInformation = "True";
        ShowFirstInputMethodInformation = "False";
        DefaultPageSize = 5;
        OverrideXkbOption = "False";
        CustomXkbOption = "";
        EnabledAddons = "";
        DisabledAddons = "";
        PreloadInputMethod = "True";
        AllowInputMethodForPassword = "False";
        ShowPreeditForPassword = "False";
        AutoSavePeriod = 30;
      };
    };
    "fcitx5/profile" = {
      force = true;
      source = (pkgs.formats.ini { }).generate "fcitx5-profile" {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-ru-srp";
        };

        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };

        "Groups/0/Items/1" = {
          Name = "keyboard-ru-srp";
          Layout = "";
        };

        "Groups/0/Items/2" = {
          Name = "mozc";
          Layout = "";
        };

        GroupOrder."0" = "Default";
      };
    };
    "fcitx5/conf/classicui.conf".source = (pkgs.formats.keyValue { }).generate "fcitx5-classicui.conf" {
      "Vertical Candidate List" = "False";
      WheelForPaging = "True";
      Font = "\"Sans 16\"";
      MenuFont = "\"Sans 12\"";
      TrayFont = "\"Monospace 12\"";
      TrayOutlineColor = "#000000";
      TrayTextColor = "#ffffff";
      PreferTextIcon = "True";
      ShowLayoutNameInIcon = "True";
      UseInputMethodLanguageToDisplayText = "True";
      Theme = "default-dark";
      DarkTheme = "default-dark";
      UseDarkTheme = "True";
      UseAccentColor = "True";
      PerScreenDPI = "True";
      ForceWaylandDPI = 0;
      EnableFractionalScale = "True";
    };
    "fcitx5/conf/imselector.conf".source = (pkgs.formats.ini { }).generate "fcitx5-imselector.conf" {
      SwitchKey = {
        "0" = "VoidSymbol";
        "1" = "Alt+Shift+Super+F6";
        "2" = "Alt+Shift+Super+F5";
      };
    };
  };
}
