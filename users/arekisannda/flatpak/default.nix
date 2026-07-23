{ ... }:
{
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.packages = [
    {
      appId = "com.usebottles.bottles";
      commit = "53692c06f12cc0ded97f7ecd32d5e414177f2416";
    }
  ];
}
