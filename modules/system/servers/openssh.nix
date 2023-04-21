{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
  users.users.default.openssh.authorizedKeys.keyFiles = [
    (__fetchurl {
      url = "https://github.com/name-snrl.keys";
      sha256 = "sha256-Fz6bYbv7lgPLayagRJozptFjqCGrirOgSCLHS5OHJpI=";
    })
  ];
}
