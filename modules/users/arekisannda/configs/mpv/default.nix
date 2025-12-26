{ pkgs, ... }:

let
  notify-send = (pkgs.callPackage ./scripts/notify-send.nix {});

  mpv-unwrapped = pkgs.mpv-unwrapped.override {
    waylandSupport = true;
    pipewireSupport = true;
    jackaudioSupport = true;
  };

  mpv = (pkgs.mpv-unwrapped.wrapper {
    scripts = with pkgs.mpvScripts; [
      mpris
    ];

    mpv = mpv-unwrapped;
  });

  mpv-service = (pkgs.mpv-unwrapped.wrapper {
    scripts = with pkgs.mpvScripts; [
      mpris
      notify-send
    ];

    mpv = mpv-unwrapped;
  });

  mpv-script = pkgs.writeShellScript "mpv-daemon" ''
    ${mpv-service}/bin/mpv --input-ipc-server=$1 --idle=yes --msg-level=all=warn
  '';
in {
  programs.mpv = {
    enable = true;
    package = mpv;
  };

  systemd.user.services.mpv = {
    Unit = {
      Description = "MPV Service";
      ConditionEnvironment = [ "DBUS_SESSION_BUS_ADDRESS" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %t/mpv";
      ExecStart = "${mpv-script} %t/mpv/socket";
      Restart = "on-failure";
      WorkingDirectory = "%h";
    };
  };
}
