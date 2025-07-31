{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ steam ];

  networking.firewall = lib.mkMerge [{
    allowedTCPPorts = [
      # 27015 # SRCDS Rcon port
      27036 # Peer discovery
      27040 # Data transfers
    ];
    allowedUDPPorts = [
      # 27015 # Gameplay traffic
      27036 # Peer discovery
    ];
    allowedUDPPortRanges = [{
      from = 27031;
      to = 27035;
    }];
  }];
}
