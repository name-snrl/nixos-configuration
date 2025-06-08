{ inputs, ... }:
{
  imports = with inputs; [
    git-hooks-nix.flakeModule
    treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, config, ... }:
    {
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

      devShells = {
        default = config.pre-commit.devShell.overrideAttrs (oa: {
          nativeBuildInputs = oa.nativeBuildInputs or [ ] ++ (with pkgs; [ bashInteractive ]);
        });

        fw-build =
          with pkgs;
          mkShellNoCC {
            packages = [
              git-lfs
              rustup
              # coreboot
              bison
              ccache
              curl
              flex
              gnat
              libuuid
              ncurses
              python3
              zlib
              # ec deps
              sdcc
              xxd
              # flash script deps
              systemd
              gawk
              rsync
              efibootmgr
            ];
            shellHook = ''
              git lfs install --local
              git lfs pull
              git submodule update --init --recursive --checkout --progress

              echo -e "
              Dependencies have been \033[0;32minstalled\033[0m.

              Follow the build instructions in \033[0;36mfirmware-open/docs/building.md\033[0m, but skip
              the dependency installation steps.

              p.s. don't forget to install \033[1;33mcoreboot-toolchain\033[0m.
              "
            '';
          }

        ;
      };

    };
}
