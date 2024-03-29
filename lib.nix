lib: with lib; rec {
  filtredReadDir =
    dir: filterAttrs (name: type: type == "directory" || hasSuffix ".nix" name) (builtins.readDir dir);

  # Package system
  forAllSystems = genAttrs systems.flakeExposed;

  unfreePkgs =
    nixpkgs: overlay: system:
    import nixpkgs {
      inherit system;
      overlays = singleton overlay;
      config.allowUnfree = true;
    };

  mkOverlays =
    dir: inputs:
    mapAttrs' (name: _: nameValuePair (removeSuffix ".nix" name) (import /${dir}/${name} inputs)) (
      filtredReadDir dir
    );

  # Modular system
  mkModuleTree =
    dir:
    mapAttrs'
      (
        name: type:
        if type == "directory" then
          nameValuePair name (mkModuleTree /${dir}/${name})
        else if name == "default.nix" then
          nameValuePair "self" /${dir}/${name}
        else
          nameValuePair (removeSuffix ".nix" name) /${dir}/${name}
      )
      (filtredReadDir dir);

  importsFromAttrs =
    {
      importByDefault,
      modules,
      imports,
    }:
    let
      modulesToList = xs: flatten (mapAttrsToList (_: v: if isPath v then v else modulesToList v) xs);
      convertedImports =
        mapAttrsRecursive
          (
            path: value:
            throwIfNot (isBool value && hasAttrByPath path modules)
              "Check the path ${concatStringsSep "." path}, the value should be of type boolean and exist in modules"
              (if value then getAttrFromPath path modules else { })
          )
          imports;
    in
    modulesToList (
      if importByDefault then recursiveUpdate modules convertedImports else convertedImports
    );

  # Hosts system
  mkHosts =
    dir: inputs:
    genAttrs (attrNames (builtins.readDir dir)) (
      name:
      nixosSystem {
        specialArgs = {
          inherit inputs importsFromAttrs;
        };
        modules = [
          /${dir}/${name}
          { networking.hostName = name; }
        ];
      }
    );

  hostsAsPkgs =
    cfgs:
    foldAttrs (x: y: x // y) { } (
      concatLists (
        forEach (attrNames cfgs) (
          name:
          with cfgs.${name};
          if name == "liveCD" then
            [ { ${pkgs.system}.${name} = config.system.build.isoImage; } ]
          else
            [ { ${pkgs.system}.${name} = config.system.build.toplevel; } ]
        )
      )
    );
}
