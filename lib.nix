inputs: with inputs.nixpkgs.lib;
rec {
  forAllSystems = genAttrs systems.flakeExposed;

  pkgsFor = system: import inputs.nixpkgs {
    overlays = [ inputs.self.overlay ];
    localSystem = { inherit system; };
    config = {
      allowUnfree = true;
      joypixels.acceptLicense = true;
    };
  };

  findModules = with builtins;
    dir: concatLists (attrValues
      (mapAttrs
        (name: type:
          if type == "regular"
          then [{
            name = elemAt (match "(.*)\\.nix" name) 0;
            value = dir + "/${name}";
          }]
          else if (readDir (dir + "/${name}")) ? "default.nix"
          then [{
            inherit name;
            value = dir + "/${name}";
          }]
          else findModules (dir + "/${name}"))
        (readDir dir)));

  attrsFromHosts = dir: genAttrs (builtins.attrNames (builtins.readDir dir));

  mkProfiles = dir: builtins.listToAttrs (findModules dir);

  mkHosts = dir: (attrsFromHosts dir)
    (name:
      nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgsFor "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ (dir + "/${name}") { networking.hostName = name; } ];
      });

  hostsAsPkgs = cfgs:
    foldAttrs (x: y: x // y) { }
      (concatLists
        (forEach (attrNames cfgs)
          (name:
            with cfgs.${name}.config.system;
            with cfgs.${name}.pkgs;
            if name == "liveCD"
            then [{ ${system}.${name} = build.isoImage; }]
            else [{ ${system}.${name} = build.toplevel; }])
        )
      );
}
