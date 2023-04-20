{pkgs, ...}: {
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
    };
  };
  users.users.default.extraGroups = [ "libvirtd" "docker" ];
  environment.systemPackages = with pkgs; [ virt-manager ];
}
