{
  lib,
  config,
  nixosConfig,
  ...
}:
let
  cfgPath = "${config.home.homeDirectory}/nixos-configuration";
  isNixos = nixosConfig != null;
  mkIfNixos = lib.mkIf isNixos;
  optionalNixosString = lib.optionalString isNixos;
in
{
  # https://github.com/nix-community/home-manager/pull/5406
  _module.args.nixosConfig = lib.mkDefault null;
  home.shellAliases = {
    ip = "ip --color=auto";
    pg = "$PAGER";
    ls = "eza --group-directories-first --group --git";
    rg = "rg --follow --hidden --glob=!.git --smart-case --no-messages";
    fd = "fd --follow --hidden";
    dt = "difft";
    cl = "cloc";
    cat = "bat --pager=never --style=changes,rule,numbers,snip";
    tree = "tree -C";
    sctl = "systemctl";
    sudo = "sudo "; # this will make sudo work with shell aliases/man alias
    reboot = "echo 'Are you sure?'; read && systemctl reboot";

    # use extended regex instead of BRE
    grep = "grep -E";
    sed = "sed -E";

    # TODO remove me
    usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";

    # cfg management
    jnp = mkIfNixos "cd ${nixosConfig.nixpkgs.flake.source}";
    nboot = mkIfNixos "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}";
    nswitch =
      if isNixos then
        "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}"
      else
        "home-manager switch --flake ${cfgPath}";
    nvmrun = mkIfNixos "nix run ${cfgPath}#nixosConfigurations.${nixosConfig.networking.hostName}.config.system.build.vm";
    nbuild =
      if isNixos then
        "nix build --no-link ${cfgPath}#${nixosConfig.networking.hostName}"
      else
        "home-manager build --no-out-link ${cfgPath}";
    nupdate = "nix flake update --commit-lock-file ${cfgPath}";
    # TODO with nix 2.19, nlock is no longer needed to update inputs
    nlock = "nix flake lock --commit-lock-file ${cfgPath}";
    # https://github.com/NixOS/nix/issues/8508
    nclear =
      optionalNixosString "sudo nix-collect-garbage --delete-old && "
      + "nix-collect-garbage --delete-old";
  };
}
