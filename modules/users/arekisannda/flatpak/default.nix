{ ... }:
{
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.packages = [
    {
      appId = "com.usebottles.bottles";
      origin = "flathub";
      commit = "c1e7e34e221bc5067ca1ff23139ebf31f26850661a5138b0dc5c78238fc3456c";
    }
  ];
}
