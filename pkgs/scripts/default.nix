{ pkgs, trimShebang }: with pkgs; {
  dict = writeShellApplication {
    name = "dict";
    runtimeInputs = [ dict ];
    text = trimShebang (lib.readFile ./dict);
  };

  sf = writeShellApplication {
    name = "sf";
    runtimeInputs = [ curl wl-clipboard ];
    text = trimShebang (lib.readFile ./sf);
  };

  sway-power = writeShellApplication {
    name = "sway-power";
    runtimeInputs = [ jq procps ];
    text = trimShebang (lib.readFile ./sway-power);
  };
}
