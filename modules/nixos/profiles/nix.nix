{ defaultUserName, ... }:
{
  nix = {
    channel.enable = false;
    settings = {
      extra-trusted-users = [ defaultUserName ];
      experimental-features = [ "ca-derivations" ];
    };
  };
}
