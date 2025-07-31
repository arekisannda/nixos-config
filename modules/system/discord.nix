{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord-canary
  ];
}
