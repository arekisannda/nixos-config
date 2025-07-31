{ ... }:

{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
          ttyname $GPG_TTY
          allow-loopback-pinentry
          pinentry-program /run/current-system/sw/bin/pinentry-rofi
        '';
    enableSshSupport = true;
  };
}
