{ pkgs, ... }:

{
  programs.firefox = with pkgs; {
    enable = true;

    package = firefox.override {
      nativeMessagingHosts = [
        tridactyl-native
        firefoxpwa
      ];
    };
  };

  home.packages = with pkgs; [
    firefoxpwa
  ];
}
