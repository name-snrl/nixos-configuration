{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nur-repo-override.url = "github:ilya-fedin/nur-repository";
    nur-repo-override.inputs.nixpkgs.follows = "nixpkgs";

    lambda-launcher.url = "github:balsoft/lambda-launcher";
    nvimpager.url = "github:lucc/nvimpager";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nvim = {
      url = "github:name-snrl/nvim";
      flake = false;
    };
    dots = {
      url = "github:name-snrl/home";
      flake = false;
    };
    hw-config = {
      url = "file:///etc/nixos/hardware-configuration.nix";
      flake = false;
    };
    CA = {
      url = "file:///root/tawasalca.crt";
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

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs system; };
        #specialArgs.inputs = inputs;
        modules = [

          ./configuration.nix
          (import inputs.hw-config)

          self.nixosModules.global_variables

          self.nixosProfiles.keyboard
          self.nixosProfiles.sway
          self.nixosProfiles.bash
          self.nixosProfiles.git
          self.nixosProfiles.neovim
          self.nixosProfiles.starship
        ];
      };

    };
}
