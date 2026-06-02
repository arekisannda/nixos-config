{ config, pkgs, ... }:

let
  gui = config.setup.gui.theme;

  signals = (import ./signals.nix);
  emit = s: "${pkgs.procps}/bin/pkill -RTMIN+${toString s} waybar";

  sm = "${pkgs.sway}/bin/swaymsg -q";
  pkill = "${pkgs.procps}/bin/pkill";

  level-format =
    icon:
    "<span letter_spacing='10368'>${icon}</span><span color='#525153' rise='1500'>⣿</span><span letter_spacing='-20736' rise='1500'>{icon}</span>";

  level-format-icons = [
    "<span color='#92bb69'>⠀</span>"
    "<span color='#9cc771'>⡀</span>"
    "<span color='#a9c47f'>⣀</span>"
    "<span color='#bac276'>⣄</span>"
    "<span color='#cbc06c'>⣤</span>"
    "<span color='#cea966'>⣦</span>"
    "<span color='#d19260'>⣶</span>"
    "<span color='#d57b59'>⣷</span>"
    "<span color='#d86453'>⣿</span>"
  ];

  modules = {
    custom-blank = {
      interval = "once";
      tooltip = false;
      format = " ";
    };

    wireplumber = {
      scroll-step = 5;
      max-volume = 100;
      format = "{icon}";
      format-muted = "󰣾";
      format-source = "";
      format-source-muted = "󰍭";
      format-icons = [
        "󰣾"
        "󰣴"
        "󰣶"
        "󰣸"
        "󰣺"
      ];
      tooltip-format = "{node_name} - {volume}";
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      on-click-right = "${pkgs.qjackctl}/bin/qjackctl";
      on-click-middle = "${sm} 'exec $volume_mute' && ${emit signals.wireplumber}";
      on-scroll-up = "${sm} 'exec $volume_up' && ${emit signals.wireplumber}";
      on-scroll-down = "${sm} 'exec $volume_down' && ${emit signals.wireplumber}";
      signal = signals.wireplumber;
    };

    sway-workspaces = {
      disable-scroll = false;
      format = "{name}";
      format-icons = { };
      window-rewrite-default = "{name}";
      window-format = "<span color='#e0e0e0'>{name}</span>";
      window-rewrite = { };
      on-update = "${emit signals.sway-workspaces}";
      on-click-middle = "${sm} exec '$once sway-new-workspace open'";
      signal = signals.sway-workspaces;
    };

    custom-mic = {
      interval = "once";
      return-type = "json";
      tooltip = true;
      format = "{icon}";
      format-icons = {
        on = " ";
        off = "●";
      };
      exec = "$HOME/.config/sway/scripts/mic-status.sh";
      on-click = "${emit signals.custom-mic}";
      signal = signals.custom-mic;
    };

    custom-mode-clock = {
      interval = 10;
      return-type = "json";
      format = "{}";
      tooltip = true;
      exec = "$HOME/.config/sway/scripts/waybar-mode-clock.sh";
      on-click = "${pkill} rofi || ${sm} 'exec $menu'";
      signal = signals.custom-mode-clock;
    };

    privacy = rec {
      icon-spacing = 6;
      icon-size = 12;
      transition-duration = 250;
      modules = [
        {
          type = "screenshare";
          tooltip = true;
          tooltip-icon-size = icon-size;
        }
        {
          type = "audio-out";
          tooltip = true;
          tooltip-icon-size = icon-size;
        }
        {
          type = "audio-in";
          tooltip = true;
          tooltip-icon-size = icon-size;
        }
      ];
    };

    custom-wf-recorder = {
      interval = "once";
      return-type = "json";
      format = "{}";
      tooltip = true;
      exec = "$HOME/.config/sway/scripts/recorder-status.sh";
      on-click = "${pkill} --signal SIGINT wf-recorder";
      signal = signals.custom-wf-recorder;
    };

    temperature = {
      thermal-zone = 3;
      tooltip = true;
      warning-threshold = 70;
      critical-threshold = 90;
      format = level-format "󰔏";
      format-critical = level-format "󰈸";
      format-icons = level-format-icons;
      tooltip-format = "{temperatureC}°C";
    };

    cpu = {
      interval = 10;
      tooltip = true;
      states = {
        warning = 70;
        critical = 90;
      };
      format = level-format "󰍛";
      format-icons = level-format-icons;
    };

    memory = {
      interval = 10;
      tooltip = true;
      states = {
        warning = 70;
        critical = 90;
      };
      format = level-format "󰘚";
      format-icons = level-format-icons;
    };

    battery = {
      interval = 30;
      tooltip = true;
      tooltip-format = "{timeTo} - {capacity}";
      states = {
        warning = 30;
        critical = 15;
      };
      full-at = 80;
      format-charging = "󰂄";
      format = "{icon}";
      format-icons = [
        "󱃍"
        "󰁺"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };

    tray = {
      icon-size = 14;
      spacing = 12;
    };

    custom-github =
      let
        gh = "${pkgs.gh}/bin/gh";
        cat = "${pkgs.coreutils}/bin/cat";
        grep = "${pkgs.gnugrep}/bin/grep";
        xdg-open = "${pkgs.xdg-utils}/bin/xdg-open";
      in
      {
        interval = 300;
        tooltip = false;
        return-type = "json";
        format = " {}";
        exec = "${gh} api '/notifications' -q '{ text= length }' | ${cat} -";
        exec-if = ''
          [ -x "$(command -v ${gh})" ] && ${gh} auth status 2>&1 | ${grep} -q -m 1 "Logged in" && \\
          ${gh} api '/notifications' -q 'length' | \\
          ${grep} -q -m 1 \"0\" ; test $? -eq 1;
        '';
        on-click = "${xdg-open} https=//github.com/notifications && sleep 30 && ${emit signals.custom-github}";
        signal = signals.custom-github;
      };

    idle-inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
      tooltip = true;
      tooltip-format-activated = "power-saving disabled";
      tooltip-format-deactivated = "power-saving enabled";
      timeout = 1440;
    };

    custom-sunset =
      let
        sunset = "$HOME/.config/sway/scripts/sunset.sh";
      in
      {
        interval = "once";
        return-type = "json";
        tooltip = true;
        format = "{icon}";
        format-icons = {
          on = "";
          off = "";
        };
        exec = "latitude=38 longitude=-122 ${sunset}";
        on-click = "${sunset} toggle; ${emit signals.custom-sunset}";
        exec-if = "${sunset} check";
        signal = signals.custom-sunset;
      };

    custom-vpn = {
      interval = 5;
      return-type = "json";
      tooltip = true;
      exec = "$HOME/.config/sway/scripts/vpn.sh";
      format = "{icon}";
      format-icons = {
        secure = "";
        insecure = "";
      };
      signal = signals.custom-vpn;
    };

    custom-focus-follows-mouse =
      let
        focus-follow-mouse = "$HOME/.config/sway/scripts/focus-follows-mouse.sh";
      in
      {
        interval = 5;
        return-type = "json";
        tooltip = true;
        exec = "${focus-follow-mouse} status";
        format = "{icon}";
        format-icons = {
          on = "";
          off = "";
        };
        on-click = "${focus-follow-mouse} toggle && ${emit signals.custom-focus-follows-mouse}";
        signal = signals.custom-focus-follows-mouse;
      };

    custom-builtin-keyboard-fw13 =
      let
        keyboard = "1:1:AT_Translated_Set_2_keyboard";
        toggle-keyboard = "$HOME/.config/sway/scripts/toggle-keyboard.sh";
      in
      {
        interval = 5;
        return-type = "json";
        tooltip = true;
        exec = "${toggle-keyboard} '${keyboard}' status";
        format = "{icon}";
        format-icons = {
          enabled = "";
          disabled = "";
        };
        on-click = "${toggle-keyboard} '${keyboard}' toggle && ${emit signals.custom-builtin-keyboard-fw13}";
        signal = signals.custom-builtin-keyboard-fw13;
      };

    backlight = {
      rotate = 90;
      format = "{icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
      tooltip-format = "Backlight: {percent}";
      on-scroll-up = "${sm} 'exec $brightness_up'";
      on-scroll-down = "${sm} 'exec $brightness_down'";
    };

    custom-notification =
      let
        swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      in
      {
        return-type = "json";
        tooltip = true;
        format = "{icon}";
        format-icons = {
          notification = "󰂚";
          none = "󰂜";
          dnd-notification = "󱅫";
          dnd-none = "󰅸";
          inhibited-notification = "󰂚";
          inhibited-none = "󰂜";
          dnd-inhibited-notification = "󱅫";
          dnd-inhibited-none = "󰅸";
        };
        exec = "${swaync-client} -swb";
        on-click = "${swaync-client} -t -sw";
        on-click-right = "${swaync-client} -C";
        on-click-middle = "${swaync-client} -d -sw";
        escape = true;
      };

    custom-clipboard =
      let
        cliphist = "${pkgs.cliphist}/bin/cliphist";
        wc = "${pkgs.coreutils}/bin/wc";
      in
      {
        interval = "once";
        return-type = "json";
        format = "";
        exec = ''
          printf '{"tooltip":"%s"}' "$(${cliphist} list | ${wc} -l) item(s) in the clipboard\r(Mid click to clear)"
        '';
        on-click = "swaymsg -q exec '$clipboard'; pkill -RTMIN+9 waybar";
        on-click-right = "swaymsg -q exec '$clipboard-del'; pkill -RTMIN+9 waybar";
        on-click-middle = "rm -f ~/.cache/cliphist/db; pkill -RTMIN+9 waybar";
        signal = signals.custom-clipboard;
      };

  };

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
