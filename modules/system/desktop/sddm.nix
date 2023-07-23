{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
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
  environment.systemPackages = let bg = "#2e3440"; in [
    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        backgroundFill = bg;
        backgroundMode = "none";
      };
    })
  ];
}
