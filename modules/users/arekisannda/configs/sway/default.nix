{ config, pkgs, ... }:

let
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;
  systemdTarget = "sway-session.target";

  sway-systemd-unit =
    { desc }:
    {
      Description = desc;
      After = [ systemdTarget ];
      PartOf = [ systemdTarget ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

  sway-systemd-install = {
    WantedBy = [ "sway-session.target" ];
  };
in
{
  xdg.configFile = {
    "sway/config" = {
      enable = true;
      force = true;
      text = ''
        include /etc/sway/config.d/*

        include $XDG_CONFIG_HOME/sway/gui.sway
        include $XDG_CONFIG_HOME/sway/config.d/*.sway
        include $XDG_CONFIG_HOME/sway/term.sway
        include $XDG_CONFIG_HOME/sway/modes/*.sway
        include $XDG_CONFIG_HOME/sway/inputs/*.sway
        include $XDG_CONFIG_HOME/sway/local/*.sway
        include $XDG_CONFIG_HOME/sway/autostarts.sway

        exec_always ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      '';
    };

    "sway/gui.sway" = {
      enable = true;
      force = true;
      text = ''
        set $background-color     ${gui.style.background.focused}
        set $background-color-alt ${gui.style.background.focusedAlt}
        set $text-color           ${gui.style.foreground.focused}
        set $text-color-alt       ${gui.style.accentAlt}
        set $selection-color      ${gui.style.foreground.unfocusedAlt}
        set $accent-color         ${gui.style.accent}
        set $accent-color-alt     ${gui.style.accentAlt}
        set $urgent-color         ${gui.style.urgent}

        #                         border
        #                         background
        #                         foreground
        #                         indicator
        #                         child border
        client.focused            ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.foreground.focused} \
                                  ${gui.style.accentAlt} \
                                  ${gui.style.foreground.unfocused}
        client.focused_tab_title  ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.foreground.focused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.foreground.unfocused}
        client.focused_inactive   ${gui.style.foreground.unfocusedAlt} \
                                  ${gui.style.background.unfocusedAlt} \
                                  ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.background.unfocused}
        client.unfocused          ${gui.style.background.unfocused} \
                                  ${gui.style.background.unfocusedAlt} \
                                  ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.background.unfocused}
        client.urgent             ${gui.style.accentAlt} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.accentAlt} \
                                  ${gui.style.accentAlt} \
                                  ${gui.style.accentAlt}
        client.placeholder        ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused}
        client.background         ${gui.style.foreground.focused}

        output * bg ${wallpaper.image} ${wallpaper.scaling} ${wallpaper.color}
        output * scale 1.0
        font pango:${gui.font.mono} ${toString gui.font.size}
      '';
    };
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  systemd.user.services = {
    "sway-mode-clock" = {
      Unit = sway-systemd-unit { desc = "Waybar Mode Clock"; };
      Install = sway-systemd-install;
      Service = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "sway-mode-clock" ''
          while /run/current-system/sw/bin/swaymsg -q -t subscribe "[\"mode\"]"; do
            /run/current-system/sw/bin/pkill -RTMIN+16 waybar
          done
        '';
      };
    };

    "sway-audio-idle-inhibit" = {
      Unit = sway-systemd-unit { desc = "Sway Audio Idle Inhibit"; };
      Install = sway-systemd-install;
      Service = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      };
    };

    "sway-lockscreen" = {
      Unit = {
        Description = "Sway lockscreen process";
        After = [ "sway-session.target" ];
        PartOf = [ "sway-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "simple";
        PassEnvironment = [ "PATH" ];
        ExecStart = "${pkgs.hyprlock}/bin/hyprlock";
        ExecStopPost = "/bin/sh -c '[ \"$SERVICE_RESULT\" = success ] && ${pkgs.systemd}/bin/loginctl unlock-session'";
        Restart = "on-failure";
        TimeoutSec = "infinity";
        RestartSec = 1;
      };
    };

    "secure-session" = {
      Unit = {
        Description = "Lock GPG agent and lock encrypted directory on session lock";
        Before = [ "sway-lockscreen.service" ];
      };
      Install = {
        WantedBy = [ "sway-lockscreen.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "lock-agents.sh" ''
          ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent;
          ${pkgs.libnotify}/bin/notify-send  -e \
            -h "string:synchronous:secure-session" \
            -i 'lock' \
            'Secure Session' \
            'Locked agents and encrypted directories'
        '';
      };
    };
  };
}
