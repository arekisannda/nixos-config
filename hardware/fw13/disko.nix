{ config, lib, ... }:

 {
  useDisko = false;

  disko.devices = lib.mkIf config.useDisko {
    disk = {
      os = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              size = "511M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            swap = {
              priority = 2;
              size = "34G";
              content = {
                type = "swap";
              };
            };
            root = {
              priority = 3;
              size = "256G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            home = {
              priority = 4;
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
    };
  };
}
