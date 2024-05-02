{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  users.users.default.extraGroups = [ "libvirtd" ];
  # nixos-containers networking
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
  };
}
