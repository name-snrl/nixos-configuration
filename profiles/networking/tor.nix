{ pkgs, ... }:
{
  services = {
    tor = {
      enable = true;
      client.enable = true;
      client.dns.enable = true;
      settings = {
        ExitNodes = "{ua}, {nl}, {gb}";
        ExcludeNodes = "{ru},{by},{kz}";
        UseBridges = true;
        ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
        Bridge = ''
          obfs4 89.58.38.13:5372 0EAD0F94886C75A6322FCA2F5ADC5C51AC18CA3B cert=HnXzqW/GHDRbqhi2qpTM1X86eIRCOKgeh3AYGvJB+aNfL9UzA4/PVyYRXjmU0BEVhcV8TQ iat-mode=0
        '';
      };
    };
    privoxy.enable = true;
    privoxy.enableTor = true;
  };
}
