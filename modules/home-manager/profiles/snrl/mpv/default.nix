{ osConfig, lib, ... }:
let
  oldHW = osConfig != null && osConfig.networking.hostName == "t440s";
  nl = "\\n\\n";
in
{
  xdg.configFile."mpv/scripts".source = lib.sourceFilesBySuffices ./. [ ".lua" ];
  programs.mpv = {
    enable = true;
    scriptOpts.osc.hidetimeout = 1500;
    config = {
      loop-playlist = "inf";

      alang = "jpn,jp,eng,en";
      slang = "eng,en";
      sub-file-paths = "**"; # require fuzzydir.lua

      sub-border-size = "1.8";
      sub-border-color = "#000000";
      sub-color = "#FFFFFF";
      sub-ass-override = "force";

      osd-font-size = 40;
      osd-duration = 1500;
      osd-on-seek = "msg-bar";
      osd-status-msg = toString [
        "[\${duration}] \${media-title}"
        "${nl}󰐑 "
        "\${playlist-pos-1} / \${playlist-count}"
        "${nl} "
        "\${playback-time} / -\${playtime-remaining}"
        "${nl}󰃨 "
        "\${demuxer-cache-duration} sec"
      ];

      force-window = true;

      hwdec = "auto-safe";
      vo = "gpu";
      gpu-context = "wayland";

      gamma = lib.mkIf oldHW 10;

      ytdl-format = lib.mkIf oldHW "bestvideo[height<=?1080][vcodec~='^((he|a)vc|h26[45])']+bestaudio/best";
    };
    bindings = {
      "a" = "cycle audio";
      "A" = "cycle audio down";
      "s" = "cycle sub";
      "S" = "cycle sub down";

      "]" = "add speed  0.1";
      "[" = "add speed -0.1 ";

      "p" = "show-text \${playlist}";
      "Ctrl+s" = "playlist-shuffle ; show-text 'Playlist has been shuffled'";

      "=" = "add video-zoom  0.05";
      "-" = "add video-zoom -0.05";

      "h" = "add video-pan-x -0.025";
      "l" = "add video-pan-x  0.025";
      "k" = "add video-pan-y -0.025";
      "j" = "add video-pan-y  0.025";

      "q" = "quit-watch-later";
      "Ctrl+q" = "quit";

      "SHARP" = "ignore";
      "Alt+s" = "ignore";
    };
  };
}
