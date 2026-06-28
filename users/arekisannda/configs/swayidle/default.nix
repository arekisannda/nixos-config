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

  lockscreen = "sway-lockscreen.service";
  lock = "${bin.systemctl} --user is-active -q ${lockscreen} || ${bin.systemctl} --user start ${lockscreen}";
in
{
  services.swayidle = {
    enable = false;

    systemdTargets = [ "sway-session.target" ];

    events = {
      lock = lock;
      before-sleep = "${bin.loginctl} lock-session";
    };

    timeouts = [
      {
        timeout = timeout.idle;
        command = "${bin.brightnessctl} -qs && ${bin.brightnessctl} -q set 0";
        resumeCommand = "${bin.brightnessctl} -qr 2>&1 | ${bin.grep} -q 'Error' && ${bin.brightnessctl} -q set 100%  || ${bin.brightnessctl} -qr";
      }
      {
        timeout = timeout.lock;
        command = "${bin.loginctl} lock-session";
      }
      {
        timeout = timeout.sleep;
        command = "${bin.systemctl} suspend";
      }
    ];
  };
}
