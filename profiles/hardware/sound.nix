{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    config.pipewire = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
      };
    };
  };
  security.rtkit.enable = true;
}
