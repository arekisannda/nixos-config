{ pkgs, stateVersion, ... }:

let
  modules = ../modules;
  system = "${modules}/system";

  importSystem = builtins.map (e: system + "/${e}.nix") [
    #system
    "base"
    "amd"
    "ssh"
    "i18n"
    "sway"
    "pipewire"
    "scripts"
    "docker"

    # languages
    "python"
    "nodejs"

    # tools
    "gpg"
    "network-tools"
    "system-tools"
    "texlive"

    # applications
    "emacs"
    "firefox"
    "steam"
    "discord"
    "vial"
  ];

  importUsers = [ ../modules/users/arekisannda/default.nix ];

  importHardware = [ ./hardware-configuration.nix ];
in {
  nixpkgs.config.allowUnfree = true;
  imports = importHardware ++ importSystem ++ importUsers;
  disabledModules = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix.settings.auto-optimize-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  hardware.bluetooth.enable = true;

  # Network Settings
  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

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

  # Default Services
  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    libinput.enable = true;
    printing.enable = true;
    logind = { powerKey = "ignore"; };
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  documentation.man.generateCaches = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = stateVersion;
}
