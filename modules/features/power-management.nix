{ ... }:

{
  services.upower = {
    enable = true;

    percentageLow = 10;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "HybridSleep";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };
}
