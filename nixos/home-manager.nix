{ inputs, vars, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs vars;
    };
    users = {
      root = { };
      ${vars.users.master.name} = { };
    };
  };
}
