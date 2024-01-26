{ pkgs, trimShebang }: with pkgs; {
  sf = writeShellApplication {
    name = "sf";
    runtimeInputs = [ curl wl-clipboard ];
    text = trimShebang (lib.readFile ./sf);
  };
}
