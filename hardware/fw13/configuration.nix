{
  users ? [ ],
  ...
}:

{
  pkgs,
  lib,
  stateVersion,
  nixos-hardware,
  ...
}:

let
  modules = ../../modules;
  featuresDir = "${modules}/features";
  usersDir = "${modules}/users";

  importFeatures = map (e: featuresDir + "/${e}.nix") [
    # system
    "base"
    "amd"
    "ssh"
    "sway"
    "pipewire"
    "docker"
    "udev"

    # tools
    "gpg"
    "network-tools"
    "system-tools"
    "clamav"

    # configuration
    "networking-steam"
  ];

  importUsers = map (u: usersDir + "/${u}/default.nix") users;

  importHardware = [
    nixos-hardware.framework-amd-ai-300-series
    ./hardware-configuration.nix
  ];
in
{
  imports = importHardware ++ importFeatures ++ importUsers;
  disabledModules = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "uas"
  ];
  boot.kernelParams = [
    "quiet"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;

  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "lazy";
      strategyOnDischarging = "lazy";
    };
  };

  # Network Settings
  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp195s0f3u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp192s0.useDHCP = lib.mkDefault true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Security Settings
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.enableFscrypt = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.greetd.gnupg = {
    enable = true;
    noAutostart = true;
    storeOnly = true;
  };

  # Default Services
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.logind.settings = {
    Login = {
      HandlePowerKey = "ignore";
    };
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;

  documentation.man.generateCaches = true;
  documentation.dev.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = stateVersion;
}
