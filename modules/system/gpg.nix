{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    paperkey
    pinentry-all
    qrencode
    zbar
  ];
}
