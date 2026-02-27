{ writeTextFile, ... }:

writeTextFile {
  name = "vial-udev-rules";
  destination = "/etc/udev/rules.d/99-vial.rules";
  text = builtins.readFile ./99-vial.rules;
}
