{ pkgs, config, ... }:

let
  gui = config.setup.gui.theme;
in
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      layer-shell = true;
      fit-to-screen = true;
      keyboard-shortcuts = false;
      image-visibility = "when-available";
      cssPriority = "application";

      control-center-margin-top = 0;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 0;
      control-center-width = 500;
      control-center-layer = "none";

      notification-2fa-action = true;
      notification-inline-replies = true;
      notification-icon-size = 48;
      notification-body-image-height = 160;
      notification-body-image-width = 200;
      notification-window-width = 500;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = false;
      script-fail-notify = true;

      scripts = { };
      notification-visibility = { };

      widgets = [
        "mpris"
        "volume"
        "backlight"
        "inhibitors"
        "dnd"
        "notifications"
      ];

      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          button-text = "Clear";
          clear-all-button = false;
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          text = "Notification Center";
          max-lines = 1;
        };
        mpris = {
          image-size = 96;
          image-radius = 6;
          blur = false;
        };
        volume = {
          label = "󰕾";
          expand-button-label = "";
          collapse-button-label = "";
          show-per-app = true;
          show-per-app-label = true;
        };
        backlight = {
          label = "󰃟";
        };
      };
    };

    style = pkgs.replaceVarsWith {
      src = ./styles/default.css;
      replacements = {
        font-family = gui.font.propo;
        font-size = toString (builtins.floor (gui.font.size * 1.4));
        background = gui.style.background.focused;
        background-alt = gui.style.background.focusedAlt;
        foreground = gui.style.foreground.focused;
        foreground-alt = gui.style.accentAlt;
        accent = gui.style.accent;
        urgent = gui.style.urgent;
      };
    };
  };
}
