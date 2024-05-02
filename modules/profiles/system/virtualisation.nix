{
  # nixos-containers networking
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
  };
}
