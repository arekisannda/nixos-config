{ pkgs, ... }:

let
  lock = "sway-lockscreen.service";

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
  };
in
{
  services.hypridle = {
    enable = true;
    systemdTarget = "sway-session.target";

    settings = {
      general = {
        inhibit_sleep = 1;
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_wayland_inhibit = false;
        lock_cmd = ''
          ${bin.systemctl} --user is-active ${lock} || ${bin.systemctl} --user start ${lock}
        '';
        unlock_cmd = "";
        before_sleep_cmd = "${bin.loginctl} lock-session";
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
