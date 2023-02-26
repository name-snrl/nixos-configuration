{ inputs, ... }: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
  users.users.default.openssh.authorizedKeys.keyFiles = [ inputs.ssh-keys ];
}
