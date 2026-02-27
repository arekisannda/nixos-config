{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.vial-udev-rules ];
}
