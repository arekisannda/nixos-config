{
  users ? [ ],
  modulesDir,
  usersDir,
  ...
}:

{
  config,
  pkgs,
  nixos-hardware,
  stateVersion,
  ...
}:

let
  importServices = [
    ./services/kodi.nix
    ./services/jellyfin.nix
  ];

  importUsers = map (u: usersDir + "/${u}/default.nix") users;
in
{
  imports = [
    nixos-hardware.common-cpu-intel
    nixos-hardware.common-gpu-amd
    ./hardware-configuration.nix
  ]
  ++ importServices
  ++ importUsers;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [
    "iwlwifi"
    "sdhci_pci"
  ];
  boot.initrd.systemd.enable = true;

  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend";
    };
  };

  networking.hostName = "media";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsN57ZNMszWa7MsBYusn4LhKGBB8Myyv7F1TfPMruJP"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  system.stateVersion = stateVersion;
}
