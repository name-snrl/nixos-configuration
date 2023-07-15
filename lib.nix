inputs: with inputs.nixpkgs.lib;
rec {
  forAllSystems = genAttrs systems.flakeExposed;

  pkgsFor = system: import inputs.nixpkgs {
    overlays = [
      inputs.self.overlay
      # TODO remove overlay and add portal.conf when a version with this PR
      # https://github.com/flatpak/xdg-desktop-portal/pull/955 appears in nixpkgs
      inputs.shlyupa.overlays.portal
      inputs.shlyupa.overlays.qt5ct
    ];
    localSystem = { inherit system; };
    config = {
      allowUnfree = true;
      joypixels.acceptLicense = true;
    };
  };

  # Module system
  mkAttrsTree = dir:
    mapAttrs'
      (name: type:
        if type == "directory"
        then nameValuePair name (mkAttrsTree /${dir}/${name})
        else nameValuePair (removeSuffix ".nix" name) /${dir}/${name})
      (filterAttrs
        (name: type:
          type == "directory" || hasSuffix ".nix" name)
        (builtins.readDir dir));

  mkModules = dir:
    let
      listOfPaths = dir: flatten (mapAttrsToList
        (name: type:
          if type == "directory"
          then [ /${dir}/${name + "Tree"} (listOfPaths /${dir}/${name}) ]
          else /${dir}/${name})
        (filterAttrs
          (name: type:
            type == "directory" || hasSuffix ".nix" name)
          (builtins.readDir dir)));
    in
    listToAttrs
      (forEach (listOfPaths dir)
        (path:
          if ! hasSuffix "Tree" (baseNameOf path) then
            if baseNameOf path == "default.nix"
            then nameValuePair (baseNameOf (dirOf path)) path
            else nameValuePair (removeSuffix ".nix" (baseNameOf path)) path
          else
            nameValuePair
              (baseNameOf path)
              (mkAttrsTree /${dirOf path}/${removeSuffix "Tree" (baseNameOf path)})
        ));

  expandTrees = modules:
    let
      f = mod:
        if isAttrs mod
        then forEach (attrValues mod) f
        else mod;
    in
    flatten (forEach modules f);

  # Hosts system TODO
  attrsFromHosts = dir: genAttrs (builtins.attrNames (builtins.readDir dir));

  mkHosts = dir: (attrsFromHosts dir)
    (name:
      nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgsFor "x86_64-linux";
        specialArgs = {
          inherit inputs expandTrees;
          inherit (inputs.self) nixosModules;
        };
        modules = [ /${dir}/${name} { networking.hostName = name; } ] ++
          filter (val: isPath val) (attrValues inputs.self.nixosModules);
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

  mkSymlinks = pkgs: links:
    listToAttrs (mapAttrsToList
      (target: linkName: rec {
        name = "${target}-as-${linkName}";
        value = pkgs.runCommand name { } ''
          mkdir -p "$out/bin"
          ln -sfn "${getExe pkgs.${target}}" "$out/bin/${linkName}"
        '';
      })
      links);
}
