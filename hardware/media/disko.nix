{ config, lib, ... }:

{
  useDisko = true;

  disko.devices = lib.mkIf config.useDisko {
    disk = {
      os = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "256G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            home = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };

      data0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "data0";
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = ["tpm2-device=auto" "token-timeout=10"];
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/mnt/data0";
                };
              };
            };
          };
        };
      };

      data1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "data1";
                settings.allowDiscards = true;
                settings.crypttabExtraOpts = ["tpm2-device=auto" "token-timeout=10"];
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/mnt/data1";
                };
              };
            };
          };
        };
      };
    };
  };
}
