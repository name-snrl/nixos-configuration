inputs: final: prev:

let
  inherit (final) lib;
in

{
  scripts = import ./scripts final;

  osc = final.callPackage ./osc { };

  nvim-full = final.nvim.override {
    repo = "https://github.com/name-snrl/nvim";
    extraName = "-full";
    viAlias = true;
    withPython3 = true;
    rebuildWithTSParsers = true;
    extraTSParsers = with final.vimPlugins.nvim-treesitter-parsers; [
      luap
      luadoc
      nix
      fish
      scala
      java
      starlark
      go
      rust
      css
      yaml
      dockerfile
    ];
    extraBinPath = with final; [
      gnumake # for required telescope-fzf-native.nvim
      gcc # for required telescope-fzf-native.nvim
      curl # for required translate.nvim
      fd # for required telescope.nvim
      ripgrep # for required telescope.nvim
      zoxide # for required telescope-zoxide

      # languages stuff
      lua-language-server
      stylua
      selene

      nixd
      nil
      nixfmt-rfc-style
      deadnix
      statix

      nodePackages.bash-language-server
      shfmt
      shellcheck

      (mdformat.withPlugins (
        p: with p; [
          mdformat-gfm
          mdformat-frontmatter
          mdformat-footnote
        ]
      ))
      languagetool-rust

      coursier
      bazel-buildtools
    ];
  };

  writeSymlinkBin =
    pkg: name:
    final.runCommand "${pkg.pname}-as-${name}" { } ''
      mkdir -p "$out/bin"
      ln -sfn "${lib.getExe pkg}" "$out/bin/${name}"
    '';
}
