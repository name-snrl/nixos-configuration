{ inputs, ... }:
{
  imports = with inputs; [
    pre-commit-hooks-nix.flakeModule
    treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, config, ... }:
    let
      cfg = (pkgs.formats.toml { }).generate "statix.toml" { disabled = disabled-lints; };
      disabled-lints = [ "repeated_keys" ];
      statix-check = pkgs.writeShellApplication {
        name = "statix";
        runtimeInputs = [ pkgs.statix ];
        text = ''
          shift
          exec statix check --config ${cfg} "$@"
        '';
      };
    in
    {
      devShells.default = pkgs.mkShellNoCC { shellHook = config.pre-commit.installationScript; };

      pre-commit.settings.hooks = {
        treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };
        statix = {
          enable = true; # check. not everything can be fixed, but we need to know what
          package = statix-check;
          settings.format = "stderr";
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt-rfc-style.enable = true;
          deadnix.enable = true;
          statix = {
            enable = true; # fix, if possible
            inherit disabled-lints;
          };
          shellcheck.enable = true;
          shfmt.enable = true;
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
            includes = [ "pkgs/scripts/*" ];
            excludes = [ "*.nix" ];
          };
          shfmt = {
            includes = [ "pkgs/scripts/*" ];
            excludes = [ "*.nix" ];
            options = [
              "--case-indent"
              "--indent"
              "4"
            ];
          };
          mdformat.options = [
            "--wrap"
            "80"
          ];
        };
      };
    };
}
