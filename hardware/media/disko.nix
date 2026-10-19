{ config, lib, ... }:

let
  nvme0 = "/dev/disk/by-id/nvme-WD_Green_SN350_1TB_220769801829";
  nvme1 = "/dev/disk/by-id/nvme-WD_Green_SN350_1TB_220769801407";

  mirrorMember = device: bootMount: {
    type = "disk";
    inherit device;
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = bootMount;
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          type = "FD00";
          content = {
            type = "mdraid";
            name = "root";
          };
        };
      };
    };
  };
in
{
  useDisko = true;

  disko.devices = lib.mkIf config.useDisko {
    disk = {
      os0 = mirrorMember nvme0 "/boot";
      os1 = mirrorMember nvme1 "/boot-fallback";

      data = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x50014ee2176a2247";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "data";
                settings.crypttabExtraOpts = [
                  "tpm2-device=auto"
                  "token-timeout=10"
                ];
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/mnt/data";
                };
              };
            };
          };
        };
      };
    };

    mdadm = {
      root = {
        type = "mdadm";
        level = 1;
        content = {
          type = "luks";
          name = "cryptroot";
          settings.allowDiscards = true;
          settings.crypttabExtraOpts = [
            "tpm2-device=auto"
            "token-timeout=10"
          ];
          content = {
            type = "lvm_pv";
            vg = "pool";
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "4G";
            content = {
              type = "swap";
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
            size = "100%FREE";
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
}
