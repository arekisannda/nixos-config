{ config, ... }:

let
  gui = config.setup.gui.theme;
in
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = gui.gtk;
        icon-theme = gui.icon;
        cursor-theme = gui.cursor;
        font-name = "${gui.font.name} ${toString gui.font.size}";
        color-scheme = gui.gtkScheme;
        monospace-font-name = "${gui.font.mono} ${toString gui.font.size}";
      };

      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
      };
    };
  };
}
