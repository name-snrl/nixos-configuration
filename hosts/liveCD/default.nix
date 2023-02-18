{ config, lib, inputs, modulesPath, ... }: {
  imports = with inputs.self.nixosProfiles; [
    inputs.self.nixosRoles.base

    keyboard
    gdm
    sway
    fonts
    portals
    git
    fish
    starship
    aliases
    bluetooth
    sound
    console
    pkgs
    mime
    programs
    environment
    openssh

    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
  ];
  boot = {
    loader.grub.memtest86.enable = true;
    initrd.includeDefaultModules = lib.mkForce true;
    supportedFilesystems = [ "vfat" ];
  };
  programs.sway.extraSessionCommands = ''
    mkdir -p ~/.config/
    cp -rf --no-preserve=mode ${inputs.dots}/.config/sway ~/.config
    ${pkgs.fd}/bin/fd -e sh -H --search-path ~ -x chmod +x
  '';
  isoImage = {
    edition = "SwayWM";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
  system.stateVersion = lib.trivial.release;
}