inputs: inputs.self.lib.mkSymlinks {
  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  foot = "xterm";
  gojq = "jq";
}
