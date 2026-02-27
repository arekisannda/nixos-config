{ ... }:

{
  virtualisation.docker = {
    enable = false;
    # Use the rootless mode - run Docker daemon as non-root user
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        log-driver = "journald";
        registry-mirrors = [ "https://mirror.gcr.io" ];
        storage-driver = "overlay2";
      };
    };
  };
}
