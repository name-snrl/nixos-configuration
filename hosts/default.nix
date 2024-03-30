{ lib, inputs, ... }:
{
  flake = {
    nixosConfigurations =
      with lib;
      let
        importsFromAttrs =
          {
            importByDefault,
            modules,
            imports,
          }:
          let
            modulesToList = xs: flatten (mapAttrsToList (_: v: if isPath v then v else modulesToList v) xs);
            convertedImports = mapAttrsRecursive (
              path: value:
              throwIfNot (isBool value && hasAttrByPath path modules)
                "Check the path ${concatStringsSep "." path}, the value should be of type boolean and exist in modules"
                (if value then getAttrFromPath path modules else { })
            ) imports;
          in
          modulesToList (
            if importByDefault then recursiveUpdate modules convertedImports else convertedImports
          );
      in
      genAttrs (filter (v: v != "default.nix") (attrNames (builtins.readDir ./.))) (
        name:
        nixosSystem {
          specialArgs = {
            inherit inputs importsFromAttrs;
          };
          modules = [
            ./${name}
            { networking.hostName = name; }
          ];
        }
      );

    packages =
      with lib;
      let
        cfgs = inputs.self.nixosConfigurations;
      in
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
  };
}
