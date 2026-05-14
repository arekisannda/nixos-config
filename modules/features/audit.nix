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
  services.clamav.daemon.settings = {
    MaxFileSize = "2147483647";
    MaxScanSize = "4000M";
    PCREMaxFileSize = "4000M";
    MaxFiles = 50000;
    MaxRecursion = 20;
    MaxDirectoryRecursion = 20;
  };

  services.clamav.updater.enable = true;
  services.clamav.fangfrisch.enable = true;

  services.clamav.fangfrisch.settings = {
    urlhaus.enabled = "yes";
    urlhaus.max_size = "10MB";
    sanesecurity.enabled = "yes";
    interservergratis.enabled = "yes";
  };
}
