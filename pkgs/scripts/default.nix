{
  writeShellApplication,
  xdragon,
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
      xdragon
      util-linux
    ];
    text = ''exec setsid dragon --on-top "$@"'';
  };

  fzf-dragon = writeShellApplication {
    name = "fzf-dragon";
    runtimeInputs = [
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
}
