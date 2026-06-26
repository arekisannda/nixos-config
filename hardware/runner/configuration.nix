{
  users ? [ ],
  modulesDir,
  usersDir,
  ...
}:

{
  lib,
  config,
  pkgs,
  nixos-hardware,
  stateVersion,
  ...
}:

let
  importServices = [ ];

  importUsers = map (u: usersDir + "/${u}/default.nix") users;
in
{
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-cpu-amd-pstate
    nixos-hardware.common-gpu-amd
    nixos-hardware.common-pc-ssd
    ./hardware-configuration.nix
  ]
  ++ importServices
  ++ importUsers;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  boot.kernelParams = [
    # There seems to be an issue with panel self-refresh (PSR) that
    # causes hangs for users.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    "amdgpu.dcdebugmask=0x10"
  ]
  # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
  ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
    "rtc_cmos.use_acpi_alarm=1"
  ];

  boot.blacklistedKernelModules = [
    "iwlwifi"
    "bluetooth"
    "btusb"
    "thunderbolt"
    "sdhci_pci"
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };


  services.fwupd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.hostName = "runner";
  networking.wireless.enable = false;
  networking.useDHCP = true;

  users.mutableUsers = false;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  sops.secrets.root_passwd = {
    key = "users/root/password";
    neededForUsers = true;
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root_passwd.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS1/QTSTIce6bBXroP8ZlJtynLNI83uARfYz5g7tVTB"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  system.stateVersion = stateVersion;
}
