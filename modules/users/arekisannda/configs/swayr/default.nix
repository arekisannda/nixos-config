{ pkgs, ... }:

{
  programs.swayr = {
    enable = true;
    settings = {
      menu = {
        executable = "${pkgs.rofi-wayland}/bin/rofi";
        args = [
          "-i"
          "-dmenu"
          "-markup-rows"
          "-show-icons"
          "-display-column-separator"
          "▓"
          "-display-columns"
          "1,2"
          "-p"
          "{prompt} "
        ];
      };

      format = {
        output_format =
          ''{name:{:<70.70}}<span alpha="20000">{id:{:>6.6}}</span>'';
        workspace_format =
          ''{name:{:70.70}}<span alpha="20000">{id:{:>6.6}}</span>'';
        container_format =
          "<b>Container</b> on workspace {workspace_name:{:<70.70}}";
        window_format =
          "{workspace_name:{:<10.10}}▓{urgency_start}{name}{urgency_end}";
        indent = "    ";
        urgency_start = ''<span background="darkred" foreground="yellow">'';
        urgency_end = "</span>";
        html_escape = true;
      };

      layout = {
        auto_tile = false;
        auto_tile_min_window_width_per_output_width = [
          [ 1024 500 ]
          [ 1280 600 ]
          [ 1400 680 ]
          [ 1440 700 ]
          [ 1600 780 ]
          [ 1920 920 ]
          [ 2560 1000 ]
          [ 3440 1000 ]
          [ 4096 1200 ]
        ];
      };

      focus.lockin_delay = 750;

      misc = {
        auto_nop_delay = 3000;
        seq_inhibit = false;
      };
    };

    systemd.enable = true;
  };
}
