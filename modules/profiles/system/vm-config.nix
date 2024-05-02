{
  virtualisation.vmVariant = {
    virtualisation = {
      cores = 2;
      memorySize = 3 * 1024;
      diskImage = null;
      # https://wiki.qemu.org/Documentation/9psetup#Performance_Considerations_(msize)
      # I set it to 1MB, but in tests there was no difference compared to the default value (16KB)
      msize = 1024 * 1024;
      sharedDirectories.experiments = {
        source = "$HOME";
        target = "/mnt/shared";
      };
      qemu.options = [
        "-cpu host"
        "-enable-kvm"
        "-device virtio-vga-gl,edid=on,xres=1920,yres=1080"
        "-display gtk,gl=on,full-screen=on,grab-on-hover=on,zoom-to-fit=off"
        "-audio pipewire,model=hda"
      ];
    };
  };
}
