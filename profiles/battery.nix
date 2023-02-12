{
  services.upower.enable = true;
  services.tlp = {
    enable = true; # TODO if laptop
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;

      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 55;
    };
  };
}
