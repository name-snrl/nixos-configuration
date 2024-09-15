{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfgPath = "${config.home.homeDirectory}/nixos-configuration";
  isModule = osConfig != null;
  mkIfModule = lib.mkIf isModule;
  optionalModuleString = lib.optionalString isModule;
in
{
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

    # TODO remove me
    usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";

    # cfg management
    jnp = mkIfModule "cd ${osConfig.nixpkgs.flake.source}";
    nboot = mkIfModule "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}";
    nswitch =
      if isModule then
        "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}"
      else
        "home-manager switch --flake ${cfgPath}";
    nvmrun = mkIfModule "nix run ${cfgPath}#nixosConfigurations.${osConfig.networking.hostName}.config.system.build.vm";
    nbuild =
      if isModule then
        "nix build --no-link ${cfgPath}#${osConfig.networking.hostName}"
      else
        "home-manager build --no-out-link ${cfgPath}";
    nupdate = "nix flake update --commit-lock-file ${cfgPath}";
    # https://github.com/NixOS/nix/issues/8508
    nclear =
      optionalModuleString "sudo nix-collect-garbage --delete-old && "
      + "nix-collect-garbage --delete-old";
  };
}
