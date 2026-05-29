{
  config,
  pkgs,
  lib,
  ...
}:

let
  terminal = config.setup.terminal;
  toIniHex = color: lib.removePrefix "#" color;
  mkColors = type: colorSet: {
    "${type}0" = toIniHex colorSet.black;
    "${type}1" = toIniHex colorSet.red;
    "${type}2" = toIniHex colorSet.green;
    "${type}3" = toIniHex colorSet.yellow;
    "${type}4" = toIniHex colorSet.blue;
    "${type}5" = toIniHex colorSet.magenta;
    "${type}6" = toIniHex colorSet.cyan;
    "${type}7" = toIniHex colorSet.white;
  };
in
{
  xdg.configFile."sway/term.sway" = {
    enable = true;
    force = true;
    text = builtins.readFile ./term.sway;
  };

  programs.foot = {
    enable = true;
    server.enable = false;
    settings = with terminal.theme; {
      environment.TERM = terminal.type;
      security.osc52 = "enabled";

      scrollback = {
        lines = 10000;
        multiplier = 5;
      };

      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };

      cursor = {
        style = "block";
        color = "${toIniHex colors.cursor.foreground} ${toIniHex colors.cursor.background}";
        beam-thickness = 1;
      };

      main = {
        shell = "${pkgs.tmux}/bin/tmux new-session -c .";
        term = terminal.type;
        font = "${font.name}:size=${toString font.size}";
        font-italic = "${font.name}:slant=italic:size=${toString font.size}";
        font-bold = "${font.name}:weight=bold:size=${toString font.size}";
        font-bold-italic = "${font.name}:weight=bold:slant=italic:size=${toString font.size}";
      };

      colors = {
        alpha = 1.0;
        background = toIniHex colors.background.normal;
        foreground = toIniHex colors.foreground.normal;
        flash = toIniHex colors.foreground.bright;
        flash-alpha = 0.5;
      }
      // (mkColors "regular" colors.normal)
      // (mkColors "bright" colors.bright)
      // (mkColors "dim" colors.dim);

      text-bindings = {
        "\\x00[" = "Control+z";
        "\\x00:" = "Alt+colon";
        "\\x00\\x1b[A" = "Control+Up";
        "\\x00\\x1b[B" = "Control+Down";
        "\\x00\\x1b[C" = "Control+Right";
        "\\x00\\x1b[D" = "Control+Left";
        "\\x1b[5;5~" = "Control+Page_Up";
        "\\x1b[6;5~" = "Control+Page_Down";
        "\\x00\\x0c" = "Control+Shift+l";
        "\\x00q" = "Control+slash";
        "\\x00?" = "Control+question";
      };

      key-bindings = {
        scrollback-up-page = "none";
        scrollback-up-half-page = "none";
        scrollback-up-line = "none";
        scrollback-down-page = "none";
        scrollback-down-half-page = "none";
        scrollback-down-line = "none";
        scrollback-home = "none";
        scrollback-end = "none";
        search-start = "none";
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
        primary-paste = "none";
        font-increase = "Control+plus Control+equal Control+KP_Add";
        font-decrease = "Control+minus Control+KP_Subtract";
        font-reset = "Control+0 Control+KP_0";
        spawn-terminal = "none";
        minimize = "none";
        maximize = "none";
        fullscreen = "none";
        # pipe-command-output=[wl-copy] none # Copy last command's output to the clipboard
        # pipe-visible=[sh -c "xurls | fuzzel | xargs -r firefox"] none
        # pipe-scrollback=[sh -c "xurls | fuzzel | xargs -r firefox"] none
        # pipe-selected=[xargs -r firefox] none
      };

      search-bindings = { };

      url-bindings = { };

      mouse-bindings = { };
    };
  };
}
