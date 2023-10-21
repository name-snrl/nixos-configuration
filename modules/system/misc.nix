{ lib, pkgs, ... }: {
  programs.adb.enable = true; # TODO if desktop
  users.users.default.extraGroups = [ "adbusers" ]; # TODO if desktop

  services = {
    dbus.implementation = "broker";
    udisks2.enable = true;
    dictd.enable = true;
    dictd.DBs = with pkgs.dictdDBs; [ wiktionary ];
  };

  documentation.man.generateCaches = true;

  # junk out
  programs.less.enable = lib.mkForce false;
  programs.nano.syntaxHighlight = false;
}
