{ ... }:

{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      ttyname $GPG_TTY
      allow-loopback-pinentry
      pinentry-program /run/current-system/sw/bin/pinentry-rofi
      default-cache-ttl 2147483647
      max-cache-ttl 2147483647
    '';
    enableSshSupport = true;
  };
}
