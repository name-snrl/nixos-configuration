{
  services.dnsmasq = {
    enable = true;
    settings.address = [
      "/eu.ngrok.io/127.0.0.1"
      "/eu.ngrok.io/::1"
      "/ngrok-free.app/127.0.0.1"
      "/ngrok-free.app/::1"
    ];
  };
}
