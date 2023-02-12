{ inputs, ... }: {
  security.pki.certificateFiles = [ inputs.CA ];
  programs.openvpn3.enable = true;
}
