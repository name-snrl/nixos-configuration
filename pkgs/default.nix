inputs: final: prev:

let
  lib = final.lib;
  lib-snrl = inputs.self.lib;
in

{
  scripts = import ./scripts {
    inherit (lib-snrl) trimShebang;
    pkgs = final;
  };

  osc = final.callPackage ./osc { };

  writeSymlinkBin =
    pkg: name:
    final.runCommand "${pkg.pname}-as-${name}" { } ''
      mkdir -p "$out/bin"
      ln -sfn "${lib.getExe pkg}" "$out/bin/${name}"
    '';
}
