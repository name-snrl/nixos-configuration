{ inputs, ... }:
{
  imports = with inputs; [
    git-hooks-nix.flakeModule
    treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = config.pre-commit.devShell.overrideAttrs (_: {
        packages = with pkgs; [ bashInteractive ];
      });

      pre-commit.settings.hooks = {
        treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };
        statix = {
          enable = true; # check. not everything can be fixed, but we need to know what
          settings.format = "stderr";
          settings.config =
            ((pkgs.formats.toml { }).generate "statix.toml" {
              disabled = config.treefmt.programs.statix.disabled-lints;
            }).outPath;
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix = {
            enable = true; # fix, if possible
            disabled-lints = [ "repeated_keys" ];
          };
          shellcheck.enable = true;
          shfmt = {
            enable = true;
            indent_size = 4;
          };
          mdformat = {
            enable = true;
            package = pkgs.mdformat.withPlugins (
              p: with p; [
                mdformat-gfm
                mdformat-frontmatter
                mdformat-footnote
              ]
            );
          };
        };
        settings.formatter = {
          shellcheck = {
            includes = [
              "pkgs/scripts/*"
              "install"
            ];
            excludes = [
              "*.nix"
              "*.envrc"
            ];
          };
          shfmt = {
            includes = [
              "pkgs/scripts/*"
              "install"
            ];
            excludes = [ "*.nix" ];
            options = [ "--case-indent" ];
          };
          mdformat.options = [
            "--wrap"
            "80"
          ];
        };
      };
    };
}
