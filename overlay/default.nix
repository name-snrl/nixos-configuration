inputs: final: prev:

let
  inherit (final) system lib;

  fromInputs = input: name: inputs.${input}.packages.${system}.${name};

  renameBin = target: name:
    prev.runCommand "${target}-as-${name}" { } ''
      mkdir -p "$out/bin"
      ln -sfn "${lib.getExe prev.${target}}" "$out/bin/${name}"
    '';
in

{
  scripts = import ./scripts.nix prev;

  # https://gitlab.gnome.org/GNOME/glib/-/issues/338
  # TODO wait for `xdg-terminal-exec`
  alacritty-as-xterm = renameBin "alacritty" "xterm";
  gojq-as-jq = renameBin "gojq" "jq";

  exo2 = fromInputs "shlyupa" "exo2";
  nerd-fonts-symbols = fromInputs "shlyupa" "nerd-fonts-symbols";
  kotatogram-desktop-with-webkit = fromInputs "shlyupa" "kotatogram-desktop-with-webkit";

  neovim-unwrapped = (fromInputs "nvim-nightly" "neovim").overrideAttrs (old: {
    # TODO Remove once neovim 0.9.0 is released.
    patches = builtins.filter
      (p:
        (if builtins.typeOf p == "set" then baseNameOf p.name else baseNameOf) != "neovim-build-make-generated-source-files-reproducible.patch")
      old.patches;
  });

  nvim = with prev;
    let
      init = "${inputs.nvim}/init.lua";
      runtime = "${inputs.nvim}";

      binPath = lib.makeBinPath [
        gnumake
        gcc

        rnix-lsp
        shellcheck
        python310Packages.python-lsp-server
        nodePackages.bash-language-server
        sumneko-lua-language-server
      ];

      binPathExtra = lib.makeBinPath [
        # TODO create issue in markdown-preview.nvim.
        # with `-P` option firefox doesn't load page
        (writeShellScriptBin "firefox-md-preview" ''
          ${firefox-wayland}/bin/firefox -P firefox-md-preview \
          --name firefox-md-preview \
          --private-window "$@"
        '')
        ltex-ls
      ];

      cfg = path:
        let
          res = neovimUtils.makeNeovimConfig {
            withRuby = false;
            vimAlias = true;
            viAlias = true;
            plugins = [
              {
                plugin = vimPlugins.markdown-preview-nvim;
                config = null;
                optional = false;
              }
            ];
          };
        in
        res // {
          wrapRc = false;
          wrapperArgs = res.wrapperArgs ++ [
            "--add-flags"
            "--cmd 'set rtp+=${runtime}' -u ${init}"
            "--suffix"
            "PATH"
            ":"
            path
          ];
        };
    in
    {
      mini = wrapNeovimUnstable neovim-unwrapped (cfg binPath);
      full = wrapNeovimUnstable neovim-unwrapped (cfg
        (builtins.concatStringsSep ":" [ binPath binPathExtra ]));
    };

  nvimpager = (inputs.nvimpager.overlays.default final prev).nvimpager.overrideAttrs (_: {
    postInstall = ''
      mv $out/bin/nvimpager $out/bin/less
      sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
      sed -i 's#rc=.*#rc=${inputs.nvim}/pager_init.lua#' $out/bin/less
    '';
  });

  imv = with prev; with builtins;
    let
      f = data: fetchurl data;
      listOfAttrs = fromJSON (readFile ./wallhaven-collection.json);
      wallpapers = concatStringsSep " " (map f listOfAttrs);

      imv-wp = writeShellScriptBin "imv-wp" ''
        ${imv}/bin/imv ${wallpapers}
      '';

      desktop = writeTextFile {
        name = "imv-wp.desktop";
        destination = "/share/applications/imv-wp.desktop";
        text = ''
          [Desktop Entry]
          Name=imv-wp
          GenericName=Image viewer
          Exec=${imv-wp}/bin/imv-wp
          Terminal=false
          Type=Application
          Categories=Graphics;2DGraphics;Viewer;
        '';
      };
    in
    symlinkJoin {
      name = "imv";
      paths = [ imv.man imv imv-wp desktop ];
    };

  # TODO create a pr to fix the pkg
  # and fix gtk2 theme colors
  graphite-gtk-theme = prev.graphite-gtk-theme.overrideAttrs (_: {
    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      name= ./install.sh \
        --tweaks darker nord \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
  });

  # https://github.com/jirutka/swaylock-effects/issues/3
  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: {
    src = prev.fetchFromGitHub {
      owner = "mortie";
      repo = "swaylock-effects";
      rev = "a8fc557b86e70f2f7a30ca9ff9b3124f89e7f204";
      sha256 = "sha256-GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
    };
  });

}
