{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      root = { };
      name_snrl = { };
    };
  };
}
