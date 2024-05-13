{ pkgs, ... }:
{
  xdg.enable = true;
  home = {
    packages = [ pkgs.nvim-full ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
  programs.less = {
    enable = true;
    keys = ''
      #command
      ^l undo-hilite
      m set-mark-bottom
      v pipe .${pkgs.ansifilter}/bin/ansifilter | nvim -R +'nnoremap <silent> <buffer> <nowait> q <Cmd>q!<CR>'\r
      V pipe v${pkgs.ansifilter}/bin/ansifilter | nvim -R +'nnoremap <silent> <buffer> <nowait> q <Cmd>q!<CR>'\r
    '';
  };
  home.sessionVariables = {
    LESS = "FRSMi";
    SYSTEMD_LESS = "FRSMi";
  };
}
