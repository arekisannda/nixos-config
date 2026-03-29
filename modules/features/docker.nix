{ ... }:

{
  virtualisation.docker = {
    enable = false;

    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      log-driver = "journald";
      registry-mirrors = [ "https://mirror.gcr.io" ];
      storage-driver = "overlay2";
    };

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
