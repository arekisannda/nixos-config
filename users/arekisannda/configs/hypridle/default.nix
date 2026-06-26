{ pkgs, ... }:

let
  timeout = {
    idle = 300;
    lock = 600;
    screen = 900;
    sleep = 1800;
  };

  bin = {
    grep = "${pkgs.gnugrep}/bin/grep";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    systemctl = "${pkgs.systemd}/bin/systemctl";
    loginctl = "${pkgs.systemd}/bin/loginctl";
    lock = "${pkgs.hyprlock}/bin/hyprlock";
    pidof = "${pkgs.procps}/bin/pidof";
    pkill = "${pkgs.procps}/bin/pkill";
  };

  lock = "${bin.systemctl} --user start secure-session.service; ${bin.pidof} hyprlock || ${bin.lock} -q --no-fade-in";
in
{
  services.hypridle = {
    enable = false;
    systemdTarget = "sway-session.target";

    settings = {
      general = {
        inhibit_sleep = 3;
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_wayland_inhibit = false;
        lock_cmd = lock;
        before_sleep_cmd = lock;
      };

      listener = [
        {
          timeout = timeout.idle;
          on-timeout = "${bin.brightnessctl} -qs && ${bin.brightnessctl} -q set 0";
          on-resume = ''
            ${bin.brightnessctl} -qr 2>&1 | ${bin.grep} -q 'Error' && \
            ${bin.brightnessctl} -q set 100% || \
            ${bin.brightnessctl} -qr
          '';
        }
        {
          timeout = timeout.lock;
          on-timeout = "${bin.loginctl} lock-session";
        }
        {
          timeout = timeout.sleep;
          on-timeout = "${bin.systemctl} suspend";
        }
      ];
    };
  };
}
