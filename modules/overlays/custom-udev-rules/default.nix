{ writeTextFile, symlinkJoin, ... }:

let
  vial-rules = writeTextFile {
    name = "vial-udev-rules";
    destination = "/etc/udev/rules.d/99-vial.rules";
    text = builtins.readFile ./99-vial.rules;
  };

  flipperz-rules = writeTextFile {
    name = "flipperz-udev-rules";
    destination = "/etc/udev/rules.d/42-flipperz.rules";
    text = builtins.readFile ./42-flipperz.rules;
  };

in
symlinkJoin {
  name = "custom-udev-rules";
  paths = [
    vial-rules
    flipperz-rules
  ];
}
