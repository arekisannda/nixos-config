{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lm_sensors
    parted
    pciutils
    usbutils
  ];
}
