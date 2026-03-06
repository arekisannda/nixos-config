{
  config,
  pkgs,
  lib,
  ...
}:

let
  terminal = config.setup.terminal;
in
{
  xdg.configFile."sway/term.sway" = {
    enable = true;
    force = true;
    text = builtins.readFile ./term.sway;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        draw_bold_text_with_bright_colors = false;

        dim = terminal.theme.colors.dim;
        bright = terminal.theme.colors.bright;
        normal = terminal.theme.colors.normal;

        footer_bar = terminal.theme.colors.footer;
        search.matches = terminal.theme.colors.search;
        selection = terminal.theme.colors.selection;

        primary = {
          background = terminal.theme.colors.background.normal;
          dim_foreground = terminal.theme.colors.foreground.dim;
          bright_foreground = terminal.theme.colors.foreground.bright;
          foreground = terminal.theme.colors.foreground.normal;
        };

        cursor = {
          cursor = terminal.theme.colors.cursor.background;
          text = terminal.theme.colors.cursor.foreground;
        };

        vi_mode_cursor = {
          cursor = terminal.theme.colors.cursor.background;
          text = terminal.theme.colors.cursor.foreground;
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
          # action = "ToggleViMode";
          chars = "\\u0000[";
          key = "Z";
          mode = "~Vi";
          mods = "Control";
        }
      ];

      scrolling = {
        history = 10000;
        multiplier = 5;
      };

      terminal.shell = {
        args = [
          "new-session"
          "-c"
          "."
        ];
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
      terminal = { };
    };
  };
}
