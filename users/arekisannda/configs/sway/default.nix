{
  config,
  pkgs,
  custompkgs,
  ...
}:

let
  wallpaper = config.setup.gui.wallpaper;
  gui = config.setup.gui.theme;
  systemdTarget = "sway-session.target";

  signals = (import ../waybar/signals.nix);
  emit = s: "${pkgs.procps}/bin/pkill -RTMIN+${toString s} waybar";

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
    "sway/config" =
      let
        wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
        cliphist = "${pkgs.cliphist}/bin/cliphist";
        condition = ''[ -x "$(command -v ${wl-paste})" ] && [ -x "$(command -v ${cliphist})" ]'';
      in
      {
        enable = true;
        force = true;
        text = ''
          include /etc/sway/config.d/*

          include ${config.xdg.configHome}/sway/gui.sway
          include ${config.xdg.configHome}/sway/config.d/*.sway
          include ${config.xdg.configHome}/sway/term.sway
          include ${config.xdg.configHome}/sway/modes/*.sway
          include ${config.xdg.configHome}/sway/inputs/*.sway
          include ${config.xdg.configHome}/sway/local/*.sway
          include ${config.xdg.configHome}/sway/autostarts.sway

          exec ${condition} && ${wl-paste} --watch ${emit signals.custom-clipboard}
          exec ${condition} && ${wl-paste} --watch ${cliphist} store
          exec_always ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        '';
      };

    "sway/bar.sway" = {
      enable = true;
      force = true;
      text = ''
        bar {
            id main
            swaybar_command true
            position top
        }

        bar {
            id side
            swaybar_command true
            position top
        }
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

  home.packages = [
    custompkgs.sway-display-manager
  ];

  systemd.user.services = {
    "sway-display-manager" = {
      Unit = sway-systemd-unit { desc = "Sway Display Manager"; };
      Install = sway-systemd-install;
      Service = {
        Type = "simple";
        PassEnvironment = [ "SWAYSOCK" ];
        ExecStart = "${custompkgs.sway-display-manager}/bin/swaydm daemon";
        Restart = "on-failure";
        TimeoutSec = "infinity";
        RestartSec = 1;
      };
    };

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
  };
}
