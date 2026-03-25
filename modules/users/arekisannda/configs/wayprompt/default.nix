{
  config,
  pkgs,
  lib,
  ...
}:

let
  gui = config.setup.gui.theme;
  toIniHex = color: lib.removePrefix "#" color;
  fontSize = n: scale: toString (builtins.floor n * scale);
in
{
  programs.wayprompt = {
    enable = true;
    package = pkgs.wayprompt;
    settings = {
      general = {
        font-regular = "${gui.font.propo}:size=${fontSize gui.font.size 1.4}";
        font-large = "${gui.font.propo}:size=${fontSize gui.font.size 1.4}";

        button-inner-padding = 5;
        vertical-padding = 10;
        horizontal-padding = 15;

        corner-radius = 5;
        border = 1;

        pin-square-size = gui.font.size;
        pin-square-amount = 16;
      };
      colours = {
        background = toIniHex gui.style.background.focused;
        border = toIniHex gui.style.accent;
        text = toIniHex gui.style.foreground.focused;
        error-text = toIniHex gui.style.urgent;

        pin-background = toIniHex gui.style.background.focusedAlt;
        pin-border = toIniHex gui.style.accent;
        pin-square = toIniHex gui.style.foreground.focused;

        ok-button = toIniHex gui.style.background.highlighted;
        ok-button-border = toIniHex gui.style.accent;
        ok-button-text = toIniHex gui.style.foreground.focused;

        not-ok-button = toIniHex gui.style.background.highlighted;
        not-ok-button-border = toIniHex gui.style.accent;
        not-ok-button-text = toIniHex gui.style.foreground.focused;

        cancel-button = toIniHex gui.style.background.highlighted;
        cancel-button-border = toIniHex gui.style.accent;
        cancel-button-text = toIniHex gui.style.foreground.focused;
      };
    };
  };
}
