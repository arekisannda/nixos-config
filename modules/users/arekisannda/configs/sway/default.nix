{ config, pkgs, ... }:

let
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;
in {
  xdg.configFile = {
    "sway/config" = {
      enable = true;
      force = true;
      text = ''
        include /etc/sway/config.d/*

        include $XDG_CONFIG_HOME/sway/gui.sway
        include $XDG_CONFIG_HOME/sway/config.d/*.sway
        include $XDG_CONFIG_HOME/sway/modes/*.sway
        include $XDG_CONFIG_HOME/sway/inputs/*.sway
        include $XDG_CONFIG_HOME/sway/local/*.sway
        include $XDG_CONFIG_HOME/sway/autostarts.sway

        exec_always ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        exec sleep 5; systemctl --user start kanshi.service
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
        client.focused            ${gui.style.accentAlt} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.foreground.focused} \
                                  ${gui.style.foreground.unfocused} \
                                  ${gui.style.accentAlt}
        client.focused_tab_title  ${gui.style.accentAlt} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.foreground.focused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.accentAlt}
        client.focused_inactive   ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused}
                                  ${gui.style.background.unfocused}
        client.unfocused          ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.foreground.unfocused} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.background.unfocused}
        client.urgent             ${gui.style.urgent} \
                                  ${gui.style.background.unfocused} \
                                  ${gui.style.urgent} \
                                  ${gui.style.accentAlt} \
                                  ${gui.style.urgent}
        client.placeholder        ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused} \
                                  ${gui.style.background.focused}
        client.background         ${gui.style.foreground.focused}

        output * bg ${wallpaper.image} ${wallpaper.scaling} ${wallpaper.color}
        font pango:${gui.font.mono} ${toString gui.font.size}
      '';
    };
  };

  systemd.user.services = {
    "sway-mode-clock" = {
      Unit = {
        Description = "Waybar Mode Clock";
        After = [ "sway-session.target" ];
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
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
      Unit = {
        Description = "Sway Audio Idle Inhibit";
        After = [ "sway-session.target" ];
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      };
    };
  };
}
