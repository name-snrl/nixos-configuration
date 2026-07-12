# There is no reason to configure nixpkgs throught home-manager options, because
# we create our configurations from flake using the
# `home-manager.lib.homeManagerConfiguration` function, that generates nixpkgs
# configuration from its pkgs argument.
{ }
