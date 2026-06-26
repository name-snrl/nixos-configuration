{
  virtualisation.vmVariant =
    { pkgs, ... }:
    {
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
        # To search for options:
        # qemu-kvm -device 'virtio-vga-gl,?'
        # qemu-kvm -device help
        qemu.options = [
          "-cpu host"
          "-enable-kvm"
          "-vga none"
          "-device virtio-gpu-gl,edid=on,xres=1920,yres=1080"
          "-audio pipewire,model=hda"

          # qemu GTK
          #"-display gtk,gl=on,full-screen=on,grab-on-hover=on,zoom-to-fit=off"

          # spice
          "-display spice-app,gl=on"
          "-spice gl=on"
          "-device virtio-serial-pci"
          "-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
          "-chardev spicevmc,id=spicechannel0,name=vdagent"
        ];
      };
      # only XWayland, but better than nothing
      services.spice-vdagentd.enable = true;
      # hack to use the clipboard. every time you want to copy something - just
      # open the clipboard manager and select what you want there.
      systemd.user.services.copyq = rec {
        script = "${pkgs.copyq}/bin/copyq";
        postStart = "${script} config item_data_threshold 8192";
        serviceConfig.Restart = "on-failure";
        environment.QT_QPA_PLATFORM = "xcb";
        wantedBy = [ "graphical-session.target" ];
      };
    };
}
