{
  services.earlyoom = {
    enable = true;
    extraArgs = [ "--prefer '(^|/)java$'" ];
  };
  systemd = {
    user.extraConfig = "DefaultOOMScoreAdjust=0";
    services."user@".serviceConfig.OOMScoreAdjust = 0;
  };
}
