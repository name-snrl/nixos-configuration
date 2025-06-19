{
  lib,
  writeShellApplication,
  dragon-drop,
  util-linux,
  chafa,
  coreutils,
  gawk,
  file,
  bat,
  fzf,
}:
{
  dg = writeShellApplication {
    name = "dg";
    runtimeInputs = [
      util-linux
    ];
    text = ''exec setsid ${lib.getExe dragon-drop} --on-top "$@"'';
  };

  fzf-dragon = writeShellApplication {
    name = "fzf-dragon";
    runtimeInputs = [
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
          exec setsid ${lib.getExe dragon-drop} --on-top --all "''${paths[@]}"
      fi
    '';
  };
}
