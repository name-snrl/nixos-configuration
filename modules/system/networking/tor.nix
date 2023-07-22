{
  services = {
    tor = {
      enable = true;
      client.enable = true;
      client.dns.enable = true;
      settings = {
        ExitNodes = "{ua}, {nl}, {gb}";
        ExcludeNodes = "{ru},{by},{kz}";
      };
    };
    privoxy.enable = true;
    privoxy.enableTor = true;
  };
}
