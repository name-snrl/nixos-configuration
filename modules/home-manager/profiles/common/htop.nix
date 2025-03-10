{ lib, config, ... }:
{
  programs.htop = {
    enable = true;
    settings =
      with config.lib.htop;
      leftMeters [
        (bar "LeftCPUs")
        (text "Blank")
        (text "DateTime")
        (text "Uptime")
        (text "LoadAverage")
        (text "Tasks")
        (text "Blank")
        (text "Swap")
        (text "Memory")
      ]
      // rightMeters [
        (bar "RightCPUs")
        (text "Blank")
        (bar "DiskIO")
        (bar "NetworkIO")
      ]
      // {
        tree_view = true;
        hide_kernel_threads = true;
        hide_userland_threads = true;
        show_program_path = false;
        highlight_base_name = true;
        show_cpu_frequency = true;
        show_cpu_temperature = true;
        cpu_count_from_one = true;
        color_scheme = 6;

        fields = with fields; [
          PID
          PGRP
          USER
          PRIORITY
          NICE
          NLWP
          PERCENT_CPU
          M_RESIDENT
          STATE
          TIME
          COMM
        ];

        "screen:Mem" = with fields; [
          PID
          OOM
          USER
          M_SIZE
          M_SHARE
          M_RESIDENT
          M_SWAP
          COMM
        ];
      };
  };
}
