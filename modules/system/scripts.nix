{ pkgs, ... }:

let
  pinentry-rofi = self: super: {
    pinentry-rofi = super.writeTextFile {
      name = "pinentry-rofi";
      destination = "/bin/pinentry-rofi";
      executable = true;
      text = builtins.readFile ../scripts/pinentry-rofi;
    };
  };
in {
  nixpkgs.overlays = [
    pinentry-rofi
  ];

  environment.systemPackages = [
    pkgs.pinentry-rofi
  ];
}

