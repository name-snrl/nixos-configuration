inputs: final: prev:

let
  lib-snrl = inputs.self.lib;
in

{
  scripts = import ./scripts { inherit (lib-snrl) trimShebang; pkgs = final; };
}
  //
lib-snrl.mkSymlinks final {
  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  foot = "xterm";
  gojq = "jq";
}
