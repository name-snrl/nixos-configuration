{ config, inputs, ... }: {
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    registry = {
      self.flake = inputs.self;
      np.flake = inputs.nixpkgs;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" config.users.users.default.name ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://ilya-fedin.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ilya-fedin.cachix.org-1:QveU24a5ePPMh82mAFSxLk1P+w97pRxqe9rh+MJqlag="
      ];
    };

    extraOptions = ''
      #use-xdg-base-directories = true # TODO uncomment me
      builders-use-substitutes = true
      # Prevent Nix from fetching the registry every time
      flake-registry = ${inputs.flake-registry}/flake-registry.json
    '';
  };
}
