{ pkgs, ... }:
{
  programs.less.commands = {
    "^l" = "undo-hilite";
    m = "set-mark-bottom";
    v = "pipe .${pkgs.ansifilter}/bin/ansifilter | nvim -R +'nnoremap <silent> <buffer> <nowait> q <Cmd>q!<CR>'\\r";
    V = "pipe v${pkgs.ansifilter}/bin/ansifilter | nvim -R +'nnoremap <silent> <buffer> <nowait> q <Cmd>q!<CR>'\\r";
  };
  environment = {
    systemPackages = with pkgs; [ nvim-full ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      DFT_DISPLAY = "inline"; # difftastic mode

      LESS = "FRSMi";
      SYSTEMD_LESS = "FRSMi";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
