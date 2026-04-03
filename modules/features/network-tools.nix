{ pkgs, ... }:

{
  users.groups.wireshark = { };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-cli;

    dumpcap.enable = true;
  };

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
