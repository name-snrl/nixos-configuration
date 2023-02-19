{ inputs, ... }: with inputs.self.nixosProfiles; {
  imports = [
    ./base.nix

    keyboard
    sway
    gdm
    fish
    aliases
    git
    starship
    dnsmasq
    tor
    bluetooth
    sound
    battery
    console
    logging
    portals
    fonts
    mime
    sysPkgs
    programs
    work
    environment
  ];
}
