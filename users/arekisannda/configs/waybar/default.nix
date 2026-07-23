{ config, pkgs, ... }@attr:

let
  gui = config.setup.gui.theme;
  modules = import ./modules.nix attr;
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  programs.waybar.style = pkgs.replaceVarsWith {
    src = ./style.css;
    replacements = {
      font-family = gui.font.propo;
      font-size = toString (builtins.floor (gui.font.size * 1.4));
    };
  };

  programs.waybar.settings = [
    {
      id = "main";
      name = "main";
      layer = "bottom";
      margin = "0px 5px 0px 5px";
      height = 30;
      position = "top";
      output = [
        "*"
      ];

      modules-left = [
        "sway/workspaces"
      ];
      modules-center = [
        "custom/wf-recorder"
        "custom/mic"
        "custom/mode-clock"
        "custom/blank"
        "custom/blank"
      ];
      modules-right = [
        "custom/github"
        "temperature"
        "cpu"
        "memory"
        "tray"
        "custom/clipboard"
        "idle_inhibitor"
        "custom/sunset"
        "custom/vpn"
        "custom/focus-follows-mouse"
        "custom/builtin-keyboard-fw13"
        "battery"
        "backlight"
        "wireplumber"
        "custom/notification"
      ];
      "backlight" = modules.backlight;
      "battery" = modules.battery;
      "cpu" = modules.cpu;
      "custom/blank" = modules.custom-blank;
      "custom/builtin-keyboard-fw13" = modules.custom-builtin-keyboard-fw13;
      "custom/clipboard" = modules.custom-clipboard;
      "custom/focus-follows-mouse" = modules.custom-focus-follows-mouse;
      "custom/mic" = modules.custom-mic;
      "custom/mode-clock" = modules.custom-mode-clock;
      "custom/notification" = modules.custom-notification;
      "custom/sunset" = modules.custom-sunset;
      "custom/vpn" = modules.custom-vpn;
      "custom/wf-recorder" = modules.custom-wf-recorder;
      "idle_inhibitor" = modules.idle-inhibitor;
      "memory" = modules.memory;
      "sway/workspaces" = modules.sway-workspaces;
      "temperature" = modules.temperature;
      "tray" = modules.tray;
      "wireplumber" = modules.wireplumber;
    }
  ];

  programs.waybar.systemd = {
    enable = true;
    targets = [ "sway-session.target" ];
  };
}
