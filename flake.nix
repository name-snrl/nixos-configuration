{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvimpager.url = "github:lucc/nvimpager";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    hw-config = {
      url = "file:///etc/nixos/hardware-configuration.nix";
      flake = false;
    };
    bash-fzf-completion = {
      url = "github:lincheney/fzf-tab-completion";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      findModules = dir:
        builtins.concatLists (builtins.attrValues (builtins.mapAttrs
          (name: type:
            if type == "regular" then [{
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = dir + "/${name}";
            }] else if (builtins.readDir (dir + "/${name}"))
              ? "default.nix" then [{
              inherit name;
              value = dir + "/${name}";
            }] else
              findModules (dir + "/${name}"))
          (builtins.readDir dir)));
    in
    {
      nixosModules = builtins.listToAttrs (findModules ./modules);

      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

    };
}
