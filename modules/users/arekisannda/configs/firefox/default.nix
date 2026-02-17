{ pkgs, nixpkgs-unstable, ... }:

{
  programs.firefox = with nixpkgs-unstable; {
    enable = true;

    package = firefox.override {
      nativeMessagingHosts = [
        tridactyl-native
        firefoxpwa
      ];
    };

    # nativeMessagingHosts = {
    #   packages = [
    #     tridactyl-native
    #     firefoxpwa
    #   ];
    # };

    # wrapperConfig = {
    #   pipewireSupport = true;
    # };
  };

  # uncomment for firefox < 121
  # environment.sessionVariables = {
  #   MOZ_DBUS_REMOTE = "1";
  #   MOZ_ENABLE_WAYLAND = "1";
  # };
}
