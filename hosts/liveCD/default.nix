{ lib, pkgs, inputs, modulesPath, byAttrs, ... }: {
  imports = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
  ];
  disabledModules = byAttrs {
    system = {
      networking.tor = false;
      hardware.battery = false;
      logging = false;
      desktop.work = false;
    };
  };
  boot = {
    loader.grub.memtest86.enable = true;
    initrd.includeDefaultModules = lib.mkForce true;
    supportedFilesystems = [ "vfat" ];
  };
  isoImage = {
    edition = "SwayWM";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
  programs.sway.extraSessionCommands = ''
    mkdir -p ~/.config/
    cp -rf --no-preserve=mode ${inputs.dots}/.config/sway ~/.config
    ${pkgs.fd}/bin/fd -e sh -H --search-path ~ -x chmod +x
  '';
  systemd.user.services.load-dots = {
    description = "Oneshot, which loads dots";
    wantedBy = [ "graphical-session-pre.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      cp --no-preserve mode -rf ${inputs.dots}/{*,.*} ~
      ${pkgs.fd}/bin/fd -e sh -H --search-path ~ -x chmod +x
    '';
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = lib.trivial.release;
}
