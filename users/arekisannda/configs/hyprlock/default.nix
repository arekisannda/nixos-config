{
  config,
  pkgs,
  utils,
  ...
}:

let
  inherit (builtins) substring floor;
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;

  hexToRgba =
    hexColor:
    let
      inherit (utils.radix) hexToInt;

      hex = substring 1 (-1) hexColor;
      len = builtins.stringLength hex;
      r = hexToInt (substring 0 2 hex);
      g = hexToInt (substring 2 2 hex);
      b = hexToInt (substring 4 2 hex);
      a = if len >= 8 then hexToInt (substring 6 2 hex) else 255;
      alpha = a / 255.0;
    in
    "rgba(${toString r}, ${toString g}, ${toString b}, ${toString alpha})";

  timeStringSize = floor (gui.font.size * 4.0);
  dateStringSize = floor (gui.font.size * 2.4);
  date = "${pkgs.coreutils-full}/bin/date";
in
{
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "Scan fingerprint to unlock";
        "fingerprint:present_message" = "Scanning...";
        "fingerprint:retry_delay" = 750;
        "pam:enabled" = true;
        "pam:module" = "hyprlock";
      };

      animations = {
        enabled = false;
      };

      background = [
        {
          monitor = "";
          color = hexToRgba wallpaper.lockscreenColor;
          path = wallpaper.image;
        }
      ];

      label = [
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${date} +"%I:%M:%S %p")"'';
          color = hexToRgba gui.style.foreground.focused;
          font_size = timeStringSize;
          font_family = gui.font.mono;
          halign = "center";
          valign = "center";
          position = "0, 10";
        }
        # Date
        {
          monitor = "";
          text = ''cmd[update:60000] echo "$(${date} +"%a, %x")"'';
          color = hexToRgba gui.style.foreground.focused;
          font_size = dateStringSize;
          font_family = gui.font.mono;
          halign = "center";
          valign = "center";
          position = "0, -40";
        }
        # Persist fprint error
        {
          monitor = "";
          text = "$FPRINTFAIL $ATTEMPTS[]";
          color = hexToRgba gui.style.urgent;
          font_size = 10;
          font_family = gui.font.mono;
          halign = "center";
          valign = "bottom";
          position = "0, 10";
        }
      ];

      input-field = [
        {
          monitor = "";
          placeholder_text = "";
          font_family = gui.font.mono;
          font_color = hexToRgba gui.style.foreground.focused;
          fail_color = hexToRgba gui.style.urgent;
          outer_color = hexToRgba gui.style.foreground.focused;
          inner_color = hexToRgba "${wallpaper.lockscreenColor}00";
          fail_text = "$FAIL $ATTEMPTS[]";
          check_color = hexToRgba gui.style.accent;
          check_text = "...";
          capslock_color = hexToRgba gui.style.accentAlt;
          numlock_color = hexToRgba gui.style.accentAlt;
          bothlock_color = hexToRgba gui.style.accentAlt;
          dots_center = true;
          dots_size = 0.1;
          fade_on_empty = true;
          hide_input = false;
          swap_font_color = true;
          outline_thickness = 0;
          shadow_passes = 0;
          halign = "center";
          valign = "center";
          position = "0, -200";
        }
      ];
    };
  };
}
