{ config, inputs, ... }:
{
  nix = {
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      builders-use-substitutes = true;
      # Prevent Nix from fetching the registry every time
      flake-registry = null;
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      trusted-users = [
        "root"
        "@wheel"
        config.users.users.default.name
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://ilya-fedin.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ilya-fedin.cachix.org-1:QveU24a5ePPMh82mAFSxLk1P+w97pRxqe9rh+MJqlag="
      ];
    };
    registry =
      let
        nixpkgs = ref: {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          inherit ref;
        };
      in
      {
        self.flake = inputs.self;
        master.to = nixpkgs "master";
        unstable.to = nixpkgs "nixpkgs-unstable";
      };
  };
}
