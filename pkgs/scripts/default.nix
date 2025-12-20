{
  lib,
  writeShellApplication,
  dragon-drop,
  util-linux,
}:
{
  dg = writeShellApplication {
    name = "dg";
    runtimeInputs = [
      util-linux
    ];
    text = ''exec setsid ${lib.getExe dragon-drop} --on-top "$@"'';
  };
}
