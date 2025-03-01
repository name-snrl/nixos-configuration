{
  services.earlyoom.enable = true;
  systemd = {
    user.extraConfig = "DefaultOOMScoreAdjust=0";
    services."user@".serviceConfig.OOMScoreAdjust = 0;
  };
}
