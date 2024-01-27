lib: with lib;
rec {
  filtredReadDir = dir:
    filterAttrs
      (name: type: type == "directory" || hasSuffix ".nix" name)
      (builtins.readDir dir);

  # Package system
  forAllSystems = genAttrs systems.flakeExposed;

  unfreePkgs = nixpkgs: overlay: system:
    import nixpkgs {
      inherit system;
      overlays = singleton overlay;
      config.allowUnfree = true;
    };

  mkOverlays = dir: inputs:
    mapAttrs'
      (name: _:
        nameValuePair (removeSuffix ".nix" name) (import /${dir}/${name} inputs))
      (filtredReadDir dir);

  trimShebang = script:
    lib.concatLines
      (lib.filter
        (line: line != "" && !(lib.hasPrefix "#!" line))
        (lib.splitString "\n" script));

  # Modular system
  moduleTreeToList = set: flatten
    (mapAttrsToList (_: v: if isPath v then v else moduleTreeToList v) set);

  mkModuleTree = dir:
    mapAttrs'
      (name: type:
        if type == "directory"
        then nameValuePair name (mkModuleTree /${dir}/${name})
        else if name == "default.nix"
        then nameValuePair "self" /${dir}/${name}
        else nameValuePair (removeSuffix ".nix" name) /${dir}/${name})
      (filtredReadDir dir);

  modulesFromAttrs = modules: set:
    moduleTreeToList
      (mapAttrsRecursive
        (path: value:
          throwIfNot (isBool value)
            ("Check the path ${concatStringsSep "." path}, "
              + "the value should be of type boolean")
            (if value then { } else getAttrFromPath path modules))
        set);

  # Hosts system
  mkHosts = dir: inputs:
    genAttrs
      (attrNames (builtins.readDir dir))
      (name: nixosSystem {
        specialArgs = {
          inherit inputs;
          byAttrs = modulesFromAttrs inputs.self.nixosModules;
        };
        modules = [
          /${dir}/${name}
          { networking.hostName = name; }
        ] ++ moduleTreeToList inputs.self.nixosModules;
      });

  hostsAsPkgs = cfgs:
    foldAttrs
      (x: y: x // y)
      { }
      (concatLists
        (forEach
          (attrNames cfgs)
          (name:
            with cfgs.${name};
            if name == "liveCD"
            then [{ ${pkgs.system}.${name} = config.system.build.isoImage; }]
            else [{ ${pkgs.system}.${name} = config.system.build.toplevel; }])
        )
      );
}
