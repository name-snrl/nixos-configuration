{
  systemd.user.services.clight.serviceConfig.StandardOutput = "null";
  systemd.services.clightd.serviceConfig.StandardOutput = "null";
  services.clight = {
    enable = true;
    settings = {
      inhibit.disabled = true;
      keyboard.disabled = true;
      dimmer.disabled = true;
      dpms.timeouts = [ (-1) (-1) ];
      backlight = {
        trans_step = 0.01;
        ac_timeouts = [ 300 900 180 ];
        batt_timeouts = [ 300 900 180 ];
      };
      sensor = {
        ac_regression_points = [
          0.01
          0.05
          0.10
          0.15
          0.20
          0.25
          0.30
          0.35
          0.40
          0.45
          0.50
          0.55
          0.60
          0.65
          0.70
          0.75
          0.80
          0.85
        ];
        batt_regression_points = [
          0.01
          0.05
          0.10
          0.15
          0.20
          0.25
          0.30
          0.35
          0.40
          0.45
          0.50
          0.55
          0.60
          0.65
          0.70
          0.75
          0.80
          0.85
        ];
      };
      daytime = {
        sunrise = "7:00";
        sunset = "23:00";
      };
      screen = {
        contrib = 0.12;
        timeouts = [ 1 (-1) ];
      };
    };
    temperature.day = 5700;
    temperature.night = 4000;
  };
}
