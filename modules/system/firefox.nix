{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    wrapperConfig = {
      pipewireSupport = true;
    };

    nativeMessagingHosts = {
      packages = with pkgs; [
        tridactyl-native
        firefoxpwa
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    firefoxpwa
  ];

  # uncomment for firefox < 121
  # environment.sessionVariables = {
  #   MOZ_DBUS_REMOTE = "1";
  #   MOZ_ENABLE_WAYLAND = "1";
  # };
}
