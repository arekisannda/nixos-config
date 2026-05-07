{ pkgs, ... }:

{
  programs.firefox = with pkgs; {
    enable = true;

    package = firefox.override {
      nativeMessagingHosts = [
        firefoxpwa
      ];
    };
  };

  home.packages = with pkgs; [
    firefoxpwa
  ];
}
