{ pkgs, ... }:

let
  vial-udev-rules = self: super: {
    vial-udev-rules = super.writeTextFile {
      name = "vial-udev-rules";
      destination = "/etc/udev/rules.d/99-vial.rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
  };
in {
  nixpkgs.overlays = [ vial-udev-rules ];

  services.udev.packages = [ pkgs.vial-udev-rules ];
}
