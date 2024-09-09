{
  nvim,
  gnumake, # for required telescope-fzf-native.nvim
  gcc, # for required telescope-fzf-native.nvim
  curl, # for required translate.nvim
  fd, # for required telescope.nvim
  ripgrep, # for required telescope.nvim
  zoxide, # for required telescope-zoxide

  # languages stuff
  lua-language-server,
  stylua,
  selene,

  nixd,
  nil,
  nixfmt-rfc-style,
  deadnix,
  statix,

  nodePackages,
  shfmt,
  shellcheck,

  mdformat,
  languagetool-rust,

  coursier,
  bazel-buildtools,
}:

nvim.override {
  repo = "https://github.com/name-snrl/nvim";
  extraName = "-full";
  viAlias = true;
  withPython3 = true;
  extraBinPath = [
    gnumake
    gcc
    curl
    fd
    ripgrep
    zoxide

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
}
