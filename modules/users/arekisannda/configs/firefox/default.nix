{ nixpkgs-unstable, ... }:

{
  programs.firefox = with nixpkgs-unstable; {
    enable = true;

    package = firefox.override {
      nativeMessagingHosts = [
        firefoxpwa
      ];
    };
  };

  home.packages = [
    nixpkgs-unstable.firefoxpwa
  ];
}
