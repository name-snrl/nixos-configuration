{ vars, ... }:
{
  nix = {
    channel.enable = false;
    settings = {
      extra-trusted-users = [ vars.users.master.name ];
      experimental-features = [ "ca-derivations" ];
    };
  };
}
