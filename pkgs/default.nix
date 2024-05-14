final: _prev:

let
  inherit (final) lib;
in

{
  scripts = final.callPackages ./scripts { };

  nvim-full = final.callPackage ./nvim-full { };

  writeSymlinkBin =
    pkg: name:
    final.runCommand "${pkg.pname}-as-${name}" { } ''
      mkdir -p "$out/bin"
      ln -sfn "${lib.getExe pkg}" "$out/bin/${name}"
    '';
}
