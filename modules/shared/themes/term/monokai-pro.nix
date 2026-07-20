{ utils, ... }:

let
  colors = import ../color-schemes/monokai-pro.nix;
in
with utils.colors;
{
  font = {
    size = 9;
    name = "SauceCodePro NFM";
  };

  colors = {
    dim = {
      black = colors.bg-alt;
      blue = (darken colors.cyan 0.12);
      cyan = (darken colors.cyan 0.12);
      green = (darken colors.green 0.12);
      magenta = (darken colors.magenta 0.12);
      red = (darken colors.red 0.12);
      white = colors.fg-alt;
      yellow = (darken colors.yellow 0.12);
    };

    bright = {
      black = colors.grey;
      blue = (lighten colors.blue 0.15);
      cyan = (lighten colors.cyan 0.15);
      green = (lighten colors.green 0.15);
      magenta = (lighten colors.magenta 0.15);
      red = (lighten colors.red 0.15);
      white = (lighten colors.fg 0.15);
      yellow = (lighten colors.yellow 0.15);
    };

    normal = {
      black = colors.bg;
      blue = colors.blue;
      cyan = colors.cyan;
      green = colors.green;
      magenta = colors.magenta;
      red = colors.red;
      white = colors.fg;
      yellow = colors.yellow;
    };

    background = {
      dim = colors.bg-alt;
      bright = (lighten colors.bg 0.18);
      normal = "#2d2a2e";
    };

    foreground = {
      dim = colors.fg-alt;
      bright = (lighten colors.fg 1.0);
      normal = colors.fg;
    };

    selection = {
      background = colors.base5;
      foreground = colors.fg;
    };

    search = {
      background = colors.orange;
      foreground = "#2d2a2e";
    };

    footer = {
      background = colors.bg;
      foreground = colors.orange;
    };

    cursor = {
      background = colors.fg;
      foreground = colors.bg;
    };
  };
}
