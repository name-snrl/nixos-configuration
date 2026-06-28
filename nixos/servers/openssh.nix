{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
  users.users.name_snrl.openssh.authorizedKeys.keyFiles = [
    (__fetchurl {
      url = "https://github.com/name-snrl.keys";
      sha256 = "sha256-Aqe3SJF5Y6WBw5hdgTgerDJ7Re5jnNcxqnFyZLcuMJ0=";
    })
  ];
}
