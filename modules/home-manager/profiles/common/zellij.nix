{
  home.shellAliases.z = "zellij";
  programs.zellij = {
    enable = true;
    # TODO configure me
    settings = {
      pane_frames = false;
      theme = "one-half-dark";
      default_layout = "disable-status-bar";
    };
    #enableFishIntegration = true;
  };
  xdg.configFile."zellij/config.kdl".text = ''
    keybinds {
        scroll {
            bind "Ctrl s" { SwitchToMode "Normal"; }
            bind "e" { EditScrollback; SwitchToMode "Normal"; }
            bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
            bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
            // uncomment this and adjust key if using copy_on_select=false
            // bind "Alt c" { Copy; }
        }
        search {
            bind "Ctrl s" { SwitchToMode "Normal"; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
            bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
            bind "n" { Search "down"; }
            bind "p" { Search "up"; }
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "w" { SearchToggleOption "Wrap"; }
            bind "o" { SearchToggleOption "WholeWord"; }
        }
        entersearch {
            bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
            bind "Enter" { SwitchToMode "Search"; }
        }
        renametab {
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
        }
        renamepane {
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenamePane; SwitchToMode "Normal"; }
        }
        shared_except {
            //bind "Ctrl q" { Quit; }
            bind "Alt n" { NewPane; }
            bind "Alt i" { MoveTab "Left"; }
            bind "Alt o" { MoveTab "Right"; }
            bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
            bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
            bind "Alt j" "Alt Down" { MoveFocus "Down"; }
            bind "Alt k" "Alt Up" { MoveFocus "Up"; }
            bind "Alt =" "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }

            bind "Ctrl q" { Detach; }
            bind "Alt s" {
                LaunchOrFocusPlugin "session-manager" {
                    floating true
                    move_to_focused_tab true
                };
                SwitchToMode "Normal"
            }

            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "Alt t" { NewTab; SwitchToMode "Normal"; }
            bind "Alt x" { CloseTab; SwitchToMode "Normal"; }
            bind "Alt 1" { GoToTab 1; SwitchToMode "Normal"; }
            bind "Alt 2" { GoToTab 2; SwitchToMode "Normal"; }
            bind "Alt 3" { GoToTab 3; SwitchToMode "Normal"; }
            bind "Alt 4" { GoToTab 4; SwitchToMode "Normal"; }
            bind "Alt 5" { GoToTab 5; SwitchToMode "Normal"; }
            bind "Alt 6" { GoToTab 6; SwitchToMode "Normal"; }
            bind "Alt 7" { GoToTab 7; SwitchToMode "Normal"; }
            bind "Alt 8" { GoToTab 8; SwitchToMode "Normal"; }
            bind "Alt 9" { GoToTab 9; SwitchToMode "Normal"; }
        }
        shared_except "normal" {
            bind "Enter" "Esc" { SwitchToMode "Normal"; }
        }
        shared_except "scroll" {
            bind "Ctrl s" { SwitchToMode "Scroll"; }
        }
    }
  '';
}
