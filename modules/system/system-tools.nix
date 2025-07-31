{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gparted
    lm_sensors
    parted
    pciutils
    usbutils
  ];
}
