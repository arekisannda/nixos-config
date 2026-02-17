{ config, pkgs, ... }:

let
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      indicator = true;
      indicator-thickness = 0;
      indicator-radius = 150;
      font = gui.font.mono;
      text-color = "${gui.style.foreground.focused}";
      text-caps-lock-color = "${gui.style.accentAlt}";
      text-caps-lock = "󰌎";
      text-ver-color = "${gui.style.foreground.focused}";
      text-ver = "...";
      text-wrong-color = "${gui.style.urgent}";
      text-wrong = "󱈸󱈸󱈸";
      text-clear-color = "${gui.style.foreground.focused}";
      text-clear = "";
      color = "${wallpaper.lockscreenColor}";
      image = wallpaper.image;
      scaling = wallpaper.lockscreenScaling;
      timestr = "%I:%M:%S %p";
      inside-color = "#00000000";
      inside-clear-color = "#00000000";
      inside-ver-color = "#00000000";
      inside-wrong-color = "#00000000";
      ring-color = "#00000000";
      ring-clear-color = "#00000000";
      ring-ver-color = "#00000000";
      ring-wrong-color = "#00000000";
      key-hl-color = "#00000000";
      bs-hl-color = "#00000000";
      line-color = "#00000000";
      line-ver-color = "#00000000";
      line-wrong-color = "#00000000";
      line-clear-color = "#00000000";
      line-uses-inside = true;
      ignore-empty-password = true;
      clock = true;
    };
  };
}
