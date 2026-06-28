{
  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [ "ca-derivations" ];
    };
  };
}
