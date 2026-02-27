{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dig
    dnsutils
    ethtool
    ldns
    mitmproxy
    mtr
    nettools
    nmap
    tcpdump
    termshark
    wireguard-tools
  ];
}
