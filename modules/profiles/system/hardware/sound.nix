{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  # run pipewire on default.target, this fixes xdg-portal startup delay
  systemd.user.services.pipewire.wantedBy = [ "default.target" ];
}
