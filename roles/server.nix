{ inputs, ... }: with inputs.self.nixosProfiles; {
  imports = [
    ./base.nix

    openssh
  ];
}
