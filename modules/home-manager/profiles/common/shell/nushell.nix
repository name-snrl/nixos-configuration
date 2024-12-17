{
  programs = {
    # This is a simple configuration of nushell to use it as a scripting
    # language. So, we don't care about aliases or detailed completion
    # configuration.
    nushell = {
      enable = true;
      # TODO https://github.com/nix-community/home-manager/pull/6184
      extraConfig = "$env.config.show_banner = false";
      environmentVariables = {
        CARAPACE_BRIDGES = "fish,bash,zsh";
        CARAPACE_EXCLUDES = "nix";
      };
    };
    carapace = {
      enable = true;
      # Carapace is a worse completion engine than the built-in solutions of
      # popular shells. For example, it cannot complete service names for
      # journalctl, commits for git or suggest completion when entering the
      # middle part. There also problem with nix3 commands:
      #
      # https://github.com/carapace-sh/carapace-bin/issues/2374
      #
      # So, enable for nushell only
      enableFishIntegration = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };
  };
}
