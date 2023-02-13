{ inputs, ... }: with inputs.self.nixosProfiles; {
  imports = [
    nix
    boot
    locale
    security
    virtualisation
    hardware
    misc
  ];
}
