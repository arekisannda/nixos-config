{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    calibre
  ];

  environment.sessionVariables = {
    CALIBRE_USE_DARK_PALETTE = "1";
  };
}
