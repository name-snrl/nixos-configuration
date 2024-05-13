{
  inputs,
  config,
  importsFromAttrs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules =
      let
        cfgPath = "~/nixos-configuration";
      in
      [
        {
          home.stateVersion = "23.11";
          home.shellAliases = {
            jnp = "cd ${config.nixpkgs.flake.source}";
            nboot = "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}";
            nswitch = "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}";
            nvmrun = "nix run ${cfgPath}#nixosConfigurations.${config.networking.hostName}.config.system.build.vm";
            nbuild = "nix build --no-link ${cfgPath}#${config.networking.hostName}";
            nupdate = "nix flake update --commit-lock-file ${cfgPath}";
            # TODO with nix 2.19, nlock is no longer needed to update inputs
            nlock = "nix flake lock --commit-lock-file ${cfgPath}";
            # https://github.com/NixOS/nix/issues/8508
            nclear = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
          };
        }
      ]
      ++ importsFromAttrs {
        importByDefault = true;
        modules = inputs.self.moduleTree.home-manager;
        imports = {
          profiles.gf = false;
        };
      };
    users = {
      root = { };
      default = { };
    };
  };
}
