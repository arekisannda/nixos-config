{ config, pkgs, ... }:

let
  terminal = config.setup.terminal;
  hexString = hex: "#${hex}";
  addHashToColors = colors: builtins.mapAttrs (_: v: hexString v) colors;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        draw_bold_text_with_bright_colors = false;

        dim = addHashToColors terminal.theme.colors.dim;
        bright = addHashToColors terminal.theme.colors.bright;
        normal = addHashToColors terminal.theme.colors.normal;

        footer_bar = addHashToColors terminal.theme.colors.footer;
        search.matches = addHashToColors terminal.theme.colors.search;
        selection = addHashToColors terminal.theme.colors.selection;

        primary = {
          background = hexString terminal.theme.colors.background.normal;
          dim_foreground = hexString terminal.theme.colors.foreground.dim;
          bright_foreground = hexString terminal.theme.colors.foreground.bright;
          foreground = hexString terminal.theme.colors.foreground.normal;
        };

        cursor = {
          cursor = hexString terminal.theme.colors.cursor.background;
          text = hexString terminal.theme.colors.cursor.foreground;
        };

        vi_mode_cursor = {
          cursor = hexString terminal.theme.colors.cursor.background;
          text = hexString terminal.theme.colors.cursor.foreground;
        };
      };

      cursor = {
        style = "Block";
        thickness = 0.15;
        unfocused_hollow = true;
        vi_mode_style = "None";
      };

      env.TERM = terminal.type;

      font = {
        size = terminal.theme.font.size;

        bold = {
          family = terminal.theme.font.name;
          style = "Bold";
        };

        bold_italic = {
          family = terminal.theme.font.name;
          style = "Bold Italic";
        };

        italic = {
          family = terminal.theme.font.name;
          style = "Italic";
        };

        normal = {
          family = terminal.theme.font.name;
          style = "Regular";
        };

        offset.x = 0;
        offset.y = 0;
      };

      keyboard.bindings = [
        {
          action = "ClearHistory";
          key = "L";
          mode = "~Vi";
          mods = "Shift|Control";
        }
        {
          action = "ReceiveChar";
          key = "L";
          mode = "~Vi";
          mods = "Control";
        }
        {
          action = "ScrollLineUp";
          key = "PageUp";
          mode = "~Vi";
          mods = "Control";
        }
        {
          action = "ScrollLineDown";
          key = "PageDown";
          mode = "~Vi";
          mods = "Control";
        }
        {
          action = "ScrollPageUp";
          key = "PageUp";
          mode = "~Vi";
          mods = "Shift|Control";
        }
        {
          action = "ScrollPageDown";
          key = "PageDown";
          mode = "~Vi";
          mods = "Shift|Control";
        }
        {
          action = "ScrollToTop";
          key = "Home";
          mode = "~Vi";
          mods = "Control";
        }
        {

          action = "ScrollToBottom";
          key = "End";
          mode = "~Vi";
          mods = "Control";
        }

        {
          action = "ToggleViMode";
          key = "Z";
          mode = "~Vi";
          mods = "Control";
        }

        {
          action = "ScrollLineDown";
          key = "Down";
          mode = "Vi";
        }

        {
          action = "ScrollPageUp";
          key = "PageUp";
          mode = "Vi";
        }

        {
          action = "ScrollPageDown";
          key = "PageDown";
          mode = "Vi";
        }

        {
          action = "ScrollToTop";
          key = "Home";
          mode = "Vi";
        }

        {
          action = "ScrollToBottom";
          key = "End";
          mode = "Vi";
        }

        {
          action = "ToggleViMode";
          key = "Z";
          mode = "Vi";
          mods = "Control";
        }

        {
          action = "None";
          key = "Space";
          mode = "Vi";
          mods = "Shift|Control";

        }
        {
          action = "ClearSelection";
          key = "Escape";
          mode = "Vi|~Search";
          mods = "None";
        }
      ];

      scrolling = {
        history = 10000;
        multiplier = 5;
      };

      terminal.shell = {
        args = ["new-session" "-c" "."];
        program = "${pkgs.tmux}/bin/tmux";
      };

      window = {
        dynamic_title = true;
        dimensions = {
          columns = 80;
          lines = 24;
        };

        padding.x = 2;
        padding.y = 2;
      };

      general.working_directory = "None";
      terminal = {};
    };
  };
}
