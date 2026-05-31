{
  config,
  pkgs,
  lib,
  ...
}:

let
  wireproxyDirectory = "${config.xdg.configHome}/wireproxy";
in
{
  home.packages = with pkgs; [
    wireproxy
  ];

  xdg.configFile."wireproxy/proxy.conf" = {
    enable = true;
    force = true;
    text = lib.generators.toINIWithGlobalSection { } {
      globalSection = {
        WGConfig = "${wireproxyDirectory}/wg.conf";
      };
      sections = {
        Socks5 = {
          BindAddress = "127.0.0.1:25344";
        };
      };
    };
  };

  systemd.user.paths."wireproxy" = {
    Unit = {
      Description = "Watch wireproxy configurations";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Path = {
      PathChanged = [ "${wireproxyDirectory}/" ];
      PathModified = [ "${wireproxyDirectory}/" ];
      Unit = "wireproxy-restart.service";
    };
  };

  systemd.user.services = {
    "wireproxy-restart" = {
      Unit = {
        Description = "Wireproxy restart bridge";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl --user restart wireproxy.service";
      };
    };

    "wireproxy" = {
      Unit = {
        Description = "Wireproxy process";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wireproxy}/bin/wireproxy -i -c ${wireproxyDirectory}/proxy.conf";
        Restart = "always";
        TimeoutSec = "infinity";
        RestartSec = 1;
      };
    };
  };
}
