{ sshAuthorizedKeys, ... }:

{
  pkgs,
  lib,
  modulesPath,
  nixpkgs-unstable,
  ...
}:

{
  build.lastModified = 1792113248;

  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  boot.kernelParams = [ "copytoram" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = sshAuthorizedKeys;

  services.fwupd.enable = true;
  services.fwupd.package = nixpkgs-unstable.fwupd;

  environment.systemPackages = with pkgs; [
    dmidecode
    ethtool
    hdparm
    lm_sensors
    mokutil
    neovim
    nvme-cli
    pciutils
    smartmontools
    stress-ng
    tmux
    usbutils
  ];
  boot.zfs.forceImportRoot = false;
}
