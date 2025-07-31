{ config, ... }:

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
      control-center-margin-bottom = 0;
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

      scripts = {};
      notification-visibility = {};

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
          label = "󰃟" ;
        };
      };
    };

    style = ''
      @define-color cc-bg @theme_bg_color;
      @define-color cc-border @theme_selected_bg_color;
      @define-color noti-border-color @theme_selected_bg_color;
      @define-color noti-bg @theme_bg_color;
      @define-color noti-bg-darker @theme_bg_color;
      @define-color noti-bg-hover @theme_unfocused_bg_color;
      @define-color noti-bg-focus @unfocused_insensitive_color;
      @define-color noti-close-bg @theme_selected_bg_color;
      @define-color noti-close-bg-hover @theme_fg_color;
      @define-color text-color @theme_fg_color;
      @define-color text-color-disabled @insensitive_bg_color;
      @define-color bg-selected @theme_selected_bg_color;
      @define-color noti-button-border #4b4b4b;
      @define-color noti-summary @warning_color;

      * {
        font-family: ${gui.font.propo};
        font-weight: bold;
        font-size: ${toString (builtins.floor (gui.font.size * 1.4))}px;
      }

      .blank-window {
        background: transparent;
      }
      
      .control-center {
        border-top: 1px solid @cc-border;
        border-bottom: 1px solid @cc-border;
        border-left: 1px solid @cc-border;
        border-right: 1px solid @cc-border;
        border-radius: 5px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7), 0 2px 6px 2px rgba(0, 0, 0, 0.3);
        transition: opacity 400ms ease-in-out, background 0.15s ease-in-out;
      }
      
      .control-center-list {
        background: transparent;
      }
      
      .control-center .notification-row:focus {
        opacity: 1;
        background: @noti-bg-hover;
        border: 1px solid @warning_color;
        border-radius: 4px;
      }
      
      .control-center .notification-row:hover {
        opacity: 1;
        background: transparent;
        border: 1px solid @warning_color;
      }
      
      .control-center-list-placeholder {
        opacity: 0.5;
      }
      
      .close-button {
        opacity: 0;
        background: @noti-close-bg;
        color: @text-color;
        text-shadow: none;
        padding: 0px;
        border-radius: 12px;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }
      
      .close-button:hover {
        opacity: 0;
        box-shadow: none;
        background: @noti-close-bg-hover;
        transition: all .15s ease-in-out;
        border: none;
      }
      
      .inline-reply {
        margin-top: 8px;
      }
      
      .inline-reply-entry {
        background: @noti-bg-darker;
        color: @text-color;
        border: 1px solid @noti-button-border;
        border-radius: 4px;
        caret-color: @text-color;
      }
      
      .inline-reply-button {
        margin-left: 4px;
        border: 1px solid @noti-button-border;
        border-radius: 4px;
        color: @text-color;
        background: @noti-bg;
      }
      
      .inline-reply-button:disabled {
        background: initial;
        color: @text-color-disabled;
        border: 1px solid transparent;
      }
      
      .inline-reply-button:hover {
        background: @noti-bg-hover;
      }
      
      .body-image {
        margin-top: 6px;
        background-color: #fff;
        border-radius: 12px;
      }
      
      .summary {
        font-size: 1.0rem;
        font-weight: 700;
        background: transparent;
        color: @noti-summary;
        text-shadow: none;
      }
      
      .time {
        font-size: 0.9rem;
        font-weight: 700;
        background: transparent;
        color: @text-color;
        text-shadow: none;
        margin-right: 18px;
      }
      
      .body {
        font-size: 0.9rem;
        font-weight: 400;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }
      
      .widget-title {
        color: @text-color;
        margin: 10px;
        font-size: 1.1rem;
      }
      
      .widget-title>button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        border: 1px solid @noti-button-border;
        box-shadow: none;
        border-radius: 100px;
        background: @noti-bg;
      }
      
      .widget-title>button:hover {
        background: @noti-bg-hover;
      }
      
      .widget-dnd {
        color: @text-color;
        margin: 10px;
        font-size: 1.1rem;
      }
      
      .widget-dnd>switch {
        font-size: initial;
        border-radius: 100px;
        border: 1px solid @noti-button-border;
        box-shadow: none;
        background: @noti-bg;
      }
      
      .widget-dnd>switch:checked {
        border: 1px solid @noti-button-border;
        background: @bg-selected;
      }
      
      .widget-dnd>switch slider {
        border: 1px solid @noti-button-border;
        border-radius: 100px;
        background: @noti-bg-hover;
      }
      
      .widget-label {
        margin: 10px;
      }
      
      .widget-label>label {
        font-size: 1.5rem;
        color: @text-color;
      }
      
      .widget-mpris .widget-mpris-player {
        padding: 8px;
        padding: 16px;
        margin: 16px 20px;
        background-color: transparent;
        border-radius: 0px;
        box-shadow: none;
      }
      
      .widget-mpris .widget-mpris-player .widget-mpris-album-art {
        border-radius: 12px;
        box-shadow: none;
      }
      
      .widget-mpris .widget-mpris-player .widget-mpris-title {
        font-weight: 700;
        font-size: 1.25rem;
      }
      
      .widget-mpris .widget-mpris-player .widget-mpris-subtitle {
        font-size: 1.1rem;
      }
      
      .widget-mpris .widget-mpris-player button:hover {
        /* The media player buttons (play, pause, next, etc...) */
        border: 1px solid @noti-button-border;
        background: @noti-bg-hover;
      }
      
      /* .widget-mpris .widget-mpris-player > box > button { */
      /*   /\* Change player control buttons *\/ */
      /*   border: 0px; */
      /*   background-color: @noti-bg-darker; */
      /* } */
      
      .widget-mpris > box > button {
        /* Change player side buttons */
        border: 0px;
        background-color: transparent;
      }
      
      .widget-mpris > box > button:hover {
        /* Change player side buttons */
        border: 0px;
        background-color: transparent;
      }
      
      .widget-mpris > box > button:disabled {
        /* Change player side buttons insensitive */
        border: 0px;
        background-color: transparent;
      }
      
      .widget-volume {
        background: @noti-bg-darker;
        padding: 8px;
        margin: 10px;
        border-radius: 100px;
        color: @text-color;
      }
      
      .widget-volume>box>button {
        background: transparent;
        border: none
      }
      
      .per-app-volume {
        padding: 4px 8px 8px;
        margin: 0 8px 8px;
        border-radius: 100px;
        background: transparent;
        border: none;
      }
      
      .widget-backlight {
        background: @noti-bg-darker;
        padding: 8px;
        margin: 10px;
        border-radius: 100px;
        font-size: 1.5rem;
        color: @text-color;
      }
      
      .widget-inhibitors {
        margin: 8px;
        font-size: 1.0rem
      }
      
      .widget-inhibitors>button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 100px;
        background: @noti-bg;
      }
      
      .widget-inhibitors>button:hover {
        background: @noti-bg-hover;
      }

      .floating-notifications {
        background: transparent;
        opacity: 0.9;
      }
      
      .floating-notifications .notification {
        box-shadow: none;
      }
      
      .notification-row {
        outline: none;
      }
      
      .notification {
        /* padding: 10px; */
        margin: 0;
        box-shadow: none;
        border: none;
        color: @text-color;
        transition: all .15s ease-in-out;
        border-radius: 4px;
        border: 1px solid @cc-border;
        min-height: 80px;
        background: @noti-bg;
      }
      
      .notification:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
        border: 1px solid @warning_color;
      }
      
      .notification-default-action,
      .notification-action {
        box-shadow: none;
        border: none;
        color: @text-color;
        transition: all .15s ease-in-out;
        border-radius: 4px;
        background: @noti-bg;
      }
      
      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
        /* border: 1px solid @warning_color; */
      }
      
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
      }
      
      .notification-content {
        padding: 15px;
      }
      
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
        background: @noti-bg-darker;
      }
      
      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        background: @noti-bg-darker;
      }
      
      .notification-group .notification-group-buttons, .notification-group .notification-group-headers {
        margin: 0 16px;
        color: @text-color;
      }
      
      .notification-group .notification-group-collapse-button,
      .notification-group .notification-group-close-all-button {
        /* Notification Group Buttons */
        border: 1px solid transparent;
        background: transparent;
      }
      
      .notification-group .notification-group-collapse-button:hover,
      .notification-group .notification-group-close-all-button:hover {
        border: 1px solid @noti-button-border;
        background: @noti-bg-hover;
      }
    '';
  };
}
