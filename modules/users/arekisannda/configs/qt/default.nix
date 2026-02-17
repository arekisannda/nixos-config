{ config, ... }:

let
  gui = config.setup.gui.theme;
in
{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
}
