{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.custom-udev-rules ];
}
