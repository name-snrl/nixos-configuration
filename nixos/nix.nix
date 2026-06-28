{
  nix = {
    channel.enable = false;
    settings = {
      extra-trusted-users = [ "name_snrl" ];
      experimental-features = [ "ca-derivations" ];
    };
  };
}
