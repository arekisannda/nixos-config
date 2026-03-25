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
  };
}
