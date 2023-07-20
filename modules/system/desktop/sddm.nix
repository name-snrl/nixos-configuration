{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "maldives";
      settings = {
        General.DisplayServer = "wayland";
        Wayland.CompositorCommand = "${pkgs.westonLite}/bin/weston --shell=fullscreen-shell.so";
        Theme.CursorTheme = "Numix-Cursor-Light";
      };
    };
  };
  environment.etc."systemd/journald@desktop-session.conf".text = ''
    [Journal]
    SystemMaxUse=200M
  '';
}
