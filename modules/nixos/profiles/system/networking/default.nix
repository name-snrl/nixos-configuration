{
  networking = {
    useNetworkd = true;
    useDHCP = false;
    nameservers = [
      "45.90.28.0#242bc4.dns.nextdns.io"
      "2a07:a8c0::#242bc4.dns.nextdns.io"
      "45.90.30.0#242bc4.dns.nextdns.io"
      "2a07:a8c1::#242bc4.dns.nextdns.io"
    ];
    timeServers = [
      "time.cloudflare.com"
      "time.google.com"
      "0.nl.pool.ntp.org"
      "1.nl.pool.ntp.org"
      "2.nl.pool.ntp.org"
      "3.nl.pool.ntp.org"
      "0.jp.pool.ntp.org"
      "1.jp.pool.ntp.org"
      "2.jp.pool.ntp.org"
      "3.jp.pool.ntp.org"
    ];
  };
  systemd.network = {
    wait-online.anyInterface = true;
    netdevs.wireCat = {
      netdevConfig = {
        Name = "wireCat";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        MIIMonitorSec = "1s";
        PrimaryReselectPolicy = "better";
      };
    };
    networks = {
      "90-ethers" = {
        bond = [ "wireCat" ];
        matchConfig = {
          Type = "ether";
          Kind = "!*"; # fix docker
        };
      };
      "90-wlans" = {
        bond = [ "wireCat" ];
        matchConfig.WLANInterfaceType = "station";
      };
      "90-wireCat" = {
        name = "wireCat";
        networkConfig = {
          DHCP = "yes";
          DNSSEC = "yes";
          DNSOverTLS = "yes";
        };
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
      };
    };
  };
}
