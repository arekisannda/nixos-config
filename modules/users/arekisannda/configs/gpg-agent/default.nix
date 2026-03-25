{ pkgs, ... }:

let
  pinentry-bin = "${pkgs.wayprompt}/bin/pinentry-wayprompt";
in
{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      ttyname $GPG_TTY
      allow-loopback-pinentry
      pinentry-program ${pinentry-bin}
      default-cache-ttl 2147483647
      max-cache-ttl 2147483647
    '';
    enableSshSupport = true;
  };
}
