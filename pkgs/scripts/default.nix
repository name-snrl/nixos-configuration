{
  writeShellApplication,
  pkgs,
  fzf,
  lib,
}:
{
  dg = writeShellApplication {
    name = "dg";
    runtimeInputs = with pkgs; [
      xdragon
      util-linux
    ];
    text = ''exec setsid dragon --on-top "$@"'';
  };

  fzf-dragon = writeShellApplication {
    name = "fzf-dragon";
    runtimeInputs = with pkgs; [
      fzf
      xdragon
      util-linux
      chafa
      coreutils
      gawk
      file
      bat
    ];
    text = ''
      readarray -t paths < <(fzf --multi --preview='${fzf.src}/bin/fzf-preview.sh {}')
      if [[ ''${#paths[@]} -gt 0 ]]; then
          exec setsid dragon --on-top --all "''${paths[@]}"
      fi
    '';
  };

  sf = writeShellApplication {
    name = "sf";
    runtimeInputs = with pkgs; [
      curl
      wl-clipboard
    ];
    text = lib.readFile ./sf;
  };
}
