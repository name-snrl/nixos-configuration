{
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = true;
      MultiProfile = "multiple";
      FastConnectable = true;
    };
  };
  environment.shellAliases = {
    btc = "bluetoothctl connect 88:D0:39:65:46:85";
    btd = "bluetoothctl disconnect";
  };
}
