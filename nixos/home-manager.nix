{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # configure root with home-manager shared modules
    users.root = { };
  };
}
