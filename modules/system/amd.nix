{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
      libva-utils
    ];

    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
}
