{ lib, pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "monospace:size=14";
        underline-offset = "3px";
        box-drawings-uses-font-glyphs = true;
        pad = "0x0 center";
      };

      bell = {
        urgent = true;
        notify = true;
        visual = true;
      };

      desktop-notifications.command = toString [
        (lib.getExe' pkgs.glib "gdbus")
        "call"
        "--session"
        "--dest=org.freedesktop.Notifications"
        "--object-path=/org/freedesktop/Notifications"
        "--method=org.freedesktop.Notifications.Notify"
        "--"
        "''"
        "0"
        "''"
        "'foot - \${title}'"
        "'\${body}'"
        "[]"
        "{}"
        "-1"
      ];

      scrollback = {
        lines = 15000;
        multiplier = 7;
        indicator-format = "line";
      };

      url = {
        launch = "${lib.getExe' pkgs.glib "gio"} open \${url}";
        osc8-underline = "always";
      };

      cursor.color = toString [
        "2b323b" # #2b323b
        "9f515a" # #9f515a
      ];
      mouse.hide-when-typing = true;

      colors = {
        alpha = "0.9";
        background = "2b323b"; # #2b323b
        foreground = "eceff4"; # #eceff4
        regular0 = "2b323b"; # #2b323b
        regular1 = "ba686b"; # #ba686b
        regular2 = "87b57f"; # #87b57f
        regular3 = "cfcb93"; # #cfcb93
        regular4 = "5b8db5"; # #5b8db5
        regular5 = "a67193"; # #a67193
        regular6 = "609aa6"; # #609aa6
        regular7 = "d8dee9"; # #d8dee9
        bright0 = "4c5866"; # #4c5866
        bright1 = "d36265"; # #d36265
        bright2 = "88ce7c"; # #88ce7c
        bright3 = "e7e18c"; # #e7e18c
        bright4 = "5297cf"; # #5297cf
        bright5 = "bf6ea3"; # #bf6ea3
        bright6 = "5baebf"; # #5baebf
        bright7 = "eceff4"; # #eceff4
        selection-foreground = "2b323b"; # #2b323b
        selection-background = "87b57f"; # #87b57f
      };

      key-bindings = {
        scrollback-up-half-page = "Page_Up";
        scrollback-down-half-page = "Page_Down";
        clipboard-copy = "Control+Shift+y";
        clipboard-paste = "Control+Shift+p";
        search-start = "Control+Shift+slash";
      };

      search-bindings = {
        scrollback-up-half-page = "Page_Up";
        scrollback-down-half-page = "Page_Down";
        commit = toString [
          "Return"
          "Control+Shift+y"
        ];
        find-prev = "Control+p";
        find-next = "Control+n";
        delete-prev-word = "Control+w";
        delete-to-end = "none"; # fuck emacs key bindings compatibility
        extend-to-word-boundary = "none"; # use extend-to-next-whitespace instead
        extend-backward-to-next-whitespace = "Control+h";
        extend-line-down = "Control+j";
        extend-line-up = "Control+k";
        extend-to-next-whitespace = "Control+l";
      };
    };
  };
}
