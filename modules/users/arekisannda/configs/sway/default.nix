{ config, pkgs, ... }:

let
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;
  hexString = hex: "#${hex}";
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
        set $background-color     ${hexString gui.style.background.focused}
        set $background-color-alt ${hexString gui.style.background.focusedAlt}
        set $text-color           ${hexString gui.style.foreground.focused}
        set $text-color-alt       ${hexString gui.style.accentAlt}
        set $selection-color      ${hexString gui.style.foreground.unfocusedAlt}
        set $accent-color         ${hexString gui.style.accent}
        set $accent-color-alt     ${hexString gui.style.accentAlt}
        set $urgent-color         ${hexString gui.style.urgent}

        #                         border
        #                         background
        #                         foreground
        #                         indicator
        #                         child border
        client.focused            ${hexString gui.style.accentAlt} \
                                  ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.foreground.focused} \
                                  ${hexString gui.style.foreground.unfocused} \
                                  ${hexString gui.style.accentAlt}
        client.focused_tab_title  ${hexString gui.style.accentAlt} \
                                  ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.foreground.focused} \
                                  ${hexString gui.style.background.unfocused} \
                                  ${hexString gui.style.accentAlt}
        client.focused_inactive   ${hexString gui.style.foreground.unfocused} \
                                  ${hexString gui.style.background.unfocused} \
                                  ${hexString gui.style.foreground.unfocused} \
                                  ${hexString gui.style.background.unfocused}
                                  ${hexString gui.style.background.unfocused}
        client.unfocused          ${hexString gui.style.foreground.unfocused} \
                                  ${hexString gui.style.background.unfocused} \
                                  ${hexString gui.style.foreground.unfocused} \
                                  ${hexString gui.style.background.unfocused} \
                                  ${hexString gui.style.background.unfocused}
        client.urgent             ${hexString gui.style.urgent} \
                                  ${hexString gui.style.background.unfocused} \
                                  ${hexString gui.style.urgent} \
                                  ${hexString gui.style.accentAlt} \
                                  ${hexString gui.style.urgent}
        client.placeholder        ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.background.focused} \
                                  ${hexString gui.style.background.focused}
        client.background         ${hexString gui.style.foreground.focused}

        output * bg ${wallpaper.image} ${wallpaper.scaling} ${
          hexString wallpaper.color
        }
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
  };
}
