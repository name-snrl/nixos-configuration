final: _prev:

let
  inherit (final) lib;
in

{
  nvim-full = final.callPackage ./nvim-full { };
}
