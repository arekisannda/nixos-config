{ nixpkgs-unstable, ... }:

let
  inherit (nixpkgs-unstable) firefox firefoxpwa;

  firefoxpwa-patched = firefoxpwa.overrideAttrs (prev: {
    libs = "${firefox.libs}:${prev.libs}";
  });
in
{
  programs.firefox = {
    enable = true;

    package = firefox.override {
      nativeMessagingHosts = [
        firefoxpwa-patched
      ];
    };
  };

  home.packages = [
    firefoxpwa-patched
  ];
}
