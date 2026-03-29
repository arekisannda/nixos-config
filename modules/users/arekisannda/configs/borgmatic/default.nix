{ config, pkgs, ... }:

let
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{
  sops.secrets.borg.key = "services/borgmatic/passphrase";

  programs.borgmatic = {
    enable = true;
    backups = {
      data = {
        location = {
          patterns = [
            "R ${config.home.homeDirectory}"
            "- ${config.home.homeDirectory}/Books"
            "- ${config.home.homeDirectory}/Music"
            "- ${config.home.homeDirectory}/Downloads"
            "- ${config.home.homeDirectory}/.thunderbird"
            "- ${config.home.homeDirectory}/.local/share/Steam"
            "- ${config.home.homeDirectory}/.local/share/docker/overlay2"
            "- ${config.home.homeDirectory}/.local/share/docker/image"
            "- ${config.home.homeDirectory}/.local/share/docker/containers"
            "- ${config.home.homeDirectory}/.local/share/docker/buildkit"
            "- ${config.home.homeDirectory}/.local/share/docker/tmp"
          ];
          repositories = [
            {
              "path" = "/run/media/${config.home.username}/backup/borg";
              "label" = "local";
            }
          ];
        };

        storage = {
          encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borg.path}";
        };

        retention = {
          keepWithin = "3H";
          keepHourly = 24;
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };

        hooks = {
          extraConfig = {
            commands = [
              {
                before = "action";
                when = [ "create" ];
                run = [
                  "${notify-send} -t 2000 \"Borg {repository_label}\" \"Creating backup {repository}\""
                ];
              }
              {
                after = "action";
                when = [ "create" ];
                run = [
                  "${notify-send} -t 2000 \"Borg {repository_label}\" \"Completed backup {repository}\""
                ];
              }
              {
                after = "error";
                run = [
                  "${notify-send} -t 2000 \"Borg {repository_label} {log_file}\" \"Error: {output}\""
                ];
              }
            ];
          };
        };
      };
    };
  };

  services.borgmatic = {
    enable = true;
    frequency = "*-*-* 12:00:00";
  };
}
