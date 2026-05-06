{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aide
    clamav
    lynis
    osquery
    unhide
  ];

  services.osquery.enable = true;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
