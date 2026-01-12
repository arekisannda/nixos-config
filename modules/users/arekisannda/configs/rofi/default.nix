{ config, ... }:

let gui = config.setup.gui.theme;
in {
  xdg.configFile = {
    "rofi/config.rasi" = {
      enable = true;
      force = true;
      text = builtins.readFile ./config.rasi;
    };

    "rofi/colors.rasi" = {
      enable = true;
      text = ''
        /* -*- mode: css; -*- */
        * {
            background:     #${gui.style.background.focused};
            background-alt: #${gui.style.background.focusedAlt};
            foreground:     #${gui.style.foreground.focused};
            selected:       #${gui.style.background.highlighted};
            accent:         #${gui.style.accent};
            active:         #${gui.style.accentAlt};
            urgent:         #${gui.style.urgent};
        }
      '';
    };

    "rofi/fonts.rasi" = {
      enable = true;
      force = true;
      text = ''
        /* -*- mode: css; -*- */
        * {
            font:       "${gui.font.propo} ${toString gui.font.size}";
            icon-theme: "${gui.icon}";
        }
      '';
    };
  };
}

