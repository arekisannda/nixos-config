{ utils, ... }:

let
  colors = import ../../../../modules/shared/themes/color-schemes/monokai-pro.nix;
in
{
  xdg.configFile."OpenSCAD/color-schemes/render/monokai-pro.json" = {
    enable = true;
    force = true;
    text = builtins.toJSON {
      name = "Monokai Pro";
      index = 2100;
      show-in-gui = true;
      colors = {
        background = colors.bg;
        axes-color = colors.fg;
        opencsg-face-front = colors.blue;
        opencsg-face-back = colors.orange;
        cgal-face-front = colors.dark-blue;
        cgal-face-back = colors.yellow;
        cgal-face-2d = colors.green;
        cgal-edge-front = colors.grey;
        cgal-edge-back = colors.grey;
        cgal-edge-2d = colors.red;
        crosshair = colors.violet;
      };
    };
  };

  xdg.configFile."OpenSCAD/color-schemes/editor/monokai-pro.json" = {
    enable = true;
    force = true;
    text = builtins.toJSON {
      name = "Monokai Pro";
      index = 2200;

      paper = colors.bg-alt;
      text = colors.fg-alt;

      caret = {
        width = 2;
        foreground = colors.fg;
        line-background = colors.bg;
      };

      colors = {
        keyword1 = colors.orange;
        keyword2 = colors.violet;
        keyword3 = colors.dark-blue;

        commentline = colors.grey;
        commentdoc = colors.grey;
        commentdockeyword = colors.yellow;

        comment = colors.grey;
        number = colors.violet;
        string = colors.green;
        operator = colors.blue;
        variable = colors.fg-alt;

        keywords = colors.magenta;
        transformations = colors.blue;
        booleans = colors.violet;
        functions = colors.green;
        models = colors.dark-blue;
        special-variable = colors.orange;

        whitespace-foreground = colors.fg;
        selection-foregroung = colors.fg;
        selection-background = colors.base5;
        margin-backround = colors.bg-alt;
        margin-foreground = colors.fg;

        matched-brace-background = colors.base5;
        matched-brace-foreground = colors.fg;

        unmatched-brace-background = colors.red;
        unmatched-brace-foreground = colors.bg;

        error-marker = "#ff0000";
        error-indicator = "#80ff0000";
        error-indicator-outline = "#ff000000";

        edge = (utils.colors.blend colors.magenta colors.violet 0.5);
      };
    };
  };
}
