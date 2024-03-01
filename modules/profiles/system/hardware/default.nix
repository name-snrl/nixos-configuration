{ config, ... }:
{
  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent =
    with config.host-specs;
    if isNull ram || (ram > 5 && ram < 10) then
      100
    else if ram < 6 then
      200
    else
      50;
  services.fstrim.enable = true;
}
