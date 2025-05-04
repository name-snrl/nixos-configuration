{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfgPath = "${config.home.homeDirectory}/nixos-configuration";
  isModule = osConfig != null;
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
    reboot = "echo 'Are you sure?'; read && systemctl reboot";

    # TODO remove me
    usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";

    # cfg management
    jnp = lib.mkIf isModule "cd ${osConfig.nixpkgs.flake.source}";
    nboot = lib.mkIf isModule "nixos-rebuild boot --use-remote-sudo --fast --flake ${cfgPath}";
    nswitch =
      if isModule then
        "nixos-rebuild switch --use-remote-sudo --fast --flake ${cfgPath}"
      else
        "home-manager switch --flake ${cfgPath}";
    nbuild =
      if isModule then
        "nix build --no-link ${cfgPath}#${osConfig.networking.hostName}"
      else
        "home-manager build --no-out-link ${cfgPath}";
    nrepl = lib.mkIf isModule "nixos-rebuild repl --flake ${cfgPath}";
    nvmrun = lib.mkIf isModule "nix run ${cfgPath}#nixosConfigurations.${osConfig.networking.hostName}.config.system.build.vm";
    nupdate = "nix flake update --commit-lock-file --flake ${cfgPath}";
    # https://github.com/NixOS/nix/issues/8508
    nclear =
      lib.optionalString isModule "sudo nix-collect-garbage --delete-old --quiet && "
      + "nix-collect-garbage --delete-old --quiet";
  };
}
