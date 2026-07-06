{
  virtualisation.vmVariant =
    { lib, pkgs, ... }:
    {
      virtualisation = {
        cores = 6;
        memorySize = 12 * 1024;
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
          "-audio pipewire,model=virtio"

          # How to choose QEMU display to use?
          #
          # I'm mainly looking for three things:
          #
          # - correct handling of host fractional scaling in the client app
          # - clipboard sharing with wayland guests
          # - good preformance
          #
          # The modern display backends provided by QEMU are:
          #
          # - gtk
          # - sdl
          # - spice
          # - dbus (not clients yet)
          #
          # Unfortunately, each of them has drawbacks.
          #
          # Let's start with clipboard sharing. The architecture looks like this:
          #
          # host clipboard <-> display client <-> qemu <-> qemu-vdagent (chardev) <-> spice-vdagent on guest <-> guest clipboard
          #
          # Here's one of the problems: clipboard sharing with wayland guests is not yet implemented in `spice-vdagent`,
          #
          # https://gitlab.freedesktop.org/spice/linux/vd_agent/-/work_items/26
          #
          # In the case of SDL, clipboard sharing is not even implemented on the QEMU side:
          #
          # https://gitlab.com/qemu-project/qemu/-/work_items/471
          #
          # As for fractional scaling, neither GTK nor SPICE clients handle host fractional scaling correctly:
          #
          # - QEMU gtk display: https://gitlab.com/qemu-project/qemu/-/work_items/1876
          # - spice-gtk(virt-manager,remmina): https://github.com/virt-manager/virt-manager/issues/524#issuecomment-2379819457
          "-display sdl,gl=on"
          #"-display gtk,gl=on,full-screen=on,grab-on-hover=on,zoom-to-fit=off"
          #"-display spice-app,gl=on"

          # qemu-vdagent
          #"-device virtio-serial"
          #"-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
          #"-chardev spicevmc,id=vdagent,name=vdagent"
        ];
      };
      #services.spice-vdagentd.enable = true;
      systemd.user.services = {
        # use a clipboard manager running as an xwayland application as an
        # intermediary between wayland applications and spice-vdagentd. whenever
        # you want to copy something - just open the clipboard manager and
        # select what you need
        #copyq = {
        #  wantedBy = [ "graphical-session.target" ];
        #  environment.QT_QPA_PLATFORM = "xcb";
        #  serviceConfig = {
        #    ExecStart = lib.getExe pkgs.copyq;
        #    PostStart = "${lib.getExe pkgs.copyq} config item_data_threshold 8192";
        #    Restart = "on-failure";
        #  };
        #};
        plasma-set-scale = {
          wantedBy = [ "plasma-workspace.target" ];
          after = [ "plasma-workspace.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${lib.getExe pkgs.kdePackages.libkscreen} output.Virtual-1.scale.1.2";
          };
        };
      };
    };
}
