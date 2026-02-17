{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  mkStringOption =
    desc: value:
    mkOption {
      type = types.str;
      default = if value != null then value else "";
      description = desc;
    };

  mkIntegerOption =
    desc: value:
    mkOption {
      type = types.int;
      default = if value != null then value else 0;
      description = desc;
    };

  colorDescription = color: "Color ${color}.";

  mkTermColorSet = type: {
    black = mkStringOption (colorDescription "${type} black") "000000";
    blue = mkStringOption (colorDescription "${type} blue") "000080";
    cyan = mkStringOption (colorDescription "${type} cyan") "008080";
    green = mkStringOption (colorDescription "${type} green") "008000";
    magenta = mkStringOption (colorDescription "${type} magenta") "800080";
    red = mkStringOption (colorDescription "${type} red") "800000";
    white = mkStringOption (colorDescription "${type} white") "ffffff";
    yellow = mkStringOption (colorDescription "${type} yellow") "808000";
  };
in
{
  options = {
    setup = {
      gui = {
        wallpaper = {
          image = mkStringOption "Background image." "";
          color = mkStringOption "Background fallback color." "";
          scaling = mkStringOption "Background  scaling mode." "center";
          lockscreenColor = mkStringOption "Lock background fallback color." "";
          lockscreenScaling = mkStringOption "Lock background  scaling mode." "center";
        };

        theme = {
          gtk = mkStringOption "GTK theme." "";
          gtkScheme = mkStringOption "GTK scheme." "";
          kvantum = mkStringOption "Kvantum theme." "";
          icon = mkStringOption "Icon theme." "";
          cursor = mkStringOption "Cursor theme." "";

          font = {
            size = mkIntegerOption "GUI font size." "";
            name = mkStringOption "GUI font name." "";
            mono = mkStringOption "GUI monospace font name." "";
            propo = mkStringOption "GUI proportional font name." "";
          };

          colors = {
            black = mkStringOption (colorDescription "black") "000000";
            blue = mkStringOption (colorDescription "blue") "000080";
            cyan = mkStringOption (colorDescription "cyan") "008080";
            gray = mkStringOption (colorDescription "gray") "c0c0c0";
            green = mkStringOption (colorDescription "green") "008000";
            magenta = mkStringOption (colorDescription "magenta") "800080";
            orange = mkStringOption (colorDescription "orange") "df5f00";
            red = mkStringOption (colorDescription "red") "800000";
            violet = mkStringOption (colorDescription "violet") "870087";
            white = mkStringOption (colorDescription "white") "ffffff";
            yellow = mkStringOption (colorDescription "yellow") "808000";
          };

          style = {
            background = {
              focused = mkStringOption (colorDescription "background focused") "";
              focusedAlt = mkStringOption (colorDescription "background focused alt") "";
              unfocused = mkStringOption (colorDescription "background unfocused") "";
              unfocusedAlt = mkStringOption (colorDescription "background unfocused alt") "";
              highlighted = mkStringOption (colorDescription "background highlighted") "";
            };

            foreground = {
              focused = mkStringOption (colorDescription "foreground focused") "";
              focusedAlt = mkStringOption (colorDescription "foreground focused alt") "";
              unfocused = mkStringOption (colorDescription "foreground unfocused") "";
              unfocusedAlt = mkStringOption (colorDescription "foreground unfocused alt") "";
              highlighted = mkStringOption (colorDescription "foreground highlighted") "";
            };

            accent = mkStringOption (colorDescription "accent") "";
            accentAlt = mkStringOption (colorDescription "accent alt") "";
            urgent = mkStringOption (colorDescription "urgent") "";
          };
        };
      };

      terminal = {
        type = mkStringOption "$TERM environment variable type" "";

        theme = {
          font = {
            size = mkIntegerOption "Terminal font size." 0;
            name = mkStringOption "Terminal font name." "";
          };

          colors = {
            dim = mkTermColorSet "dim";
            bright = mkTermColorSet "bright";
            normal = mkTermColorSet "normal";

            background = {
              dim = mkStringOption (colorDescription "dim background") "000000";
              bright = mkStringOption (colorDescription "bright background") "000000";
              normal = mkStringOption (colorDescription "background") "000000";
            };

            foreground = {
              dim = mkStringOption (colorDescription "dim background") "ffffff";
              bright = mkStringOption (colorDescription "bright background") "ffffff";
              normal = mkStringOption (colorDescription "background") "ffffff";
            };

            selection = {
              background = mkStringOption "Selection background." "ffffff";
              foreground = mkStringOption "Selection foreground." "000000";
            };

            search = {
              background = mkStringOption "Search background." "df5f00";
              foreground = mkStringOption "Search foreground." "000000";
            };

            footer = {
              background = mkStringOption "Search background." "000000";
              foreground = mkStringOption "Search foreground." "df5f00";
            };

            cursor = {
              background = mkStringOption "Cursor background." "ffffff";
              foreground = mkStringOption "Cursor foreground." "000000";
            };
          };
        };
      };
    };
  };

  config = { };
}
