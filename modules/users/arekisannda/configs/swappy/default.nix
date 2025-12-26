{ pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  iniFormat = pkgs.formats.ini { };

  settings = {
    Default = {
      save_dir = "$HOME/Screenshots";
      save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
      show_panel = "false";
      line_size = 5;
      text_size = 20;
      text_font = "sans-serif";
      paint_mode = "brush";
      early_exit = "false";
      fill_shape = "false";
    };
  };
in {
  xdg.configFile."swappy/config" = {
    source = iniFormat.generate "swappy-config" settings;
  };
}
