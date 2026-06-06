{ config, pkgs, ... }:

{
  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;
  services.pulseaudio.enable = false;
  services.pipewire.enable = false;

  sops.secrets."jellyfin_cert.pem" = {
    key = "certificates/jellyfin/cert.pem";
    owner = "jellyfin";
  };

  sops.secrets."jellyfin_key.pem" = {
    key = "certificates/jellyfin/key.pem";
    owner = "jellyfin";
  };

  sops.secrets.jellyfin-cert-pass = {
    key = "certificates/jellyfin/password";
    owner = "jellyfin";
  };

  sops.templates.jellyfin-network = {
    content = ''
      <?xml version="1.0" encoding="utf-8"?>
      <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <BaseUrl />
        <EnableHttps>true</EnableHttps>
        <RequireHttps>false</RequireHttps>
        <CertificatePath>/var/lib/jellyfin/ssl/jellyfin.pfx</CertificatePath>
        <CertificatePassword>${config.sops.placeholder.jellyfin-cert-pass}</CertificatePassword>
        <InternalHttpPort>8096</InternalHttpPort>
        <InternalHttpsPort>8920</InternalHttpsPort>
        <PublicHttpPort>80</PublicHttpPort>
        <PublicHttpsPort>443</PublicHttpsPort>
        <AutoDiscovery>true</AutoDiscovery>
        <EnableIPv4>true</EnableIPv4>
        <EnableIPv6>false</EnableIPv6>
        <EnableRemoteAccess>true</EnableRemoteAccess>
        <LocalNetworkSubnets />
        <LocalNetworkAddresses />
        <KnownProxies />
        <IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
        <VirtualInterfaceNames>
          <string>veth</string>
        </VirtualInterfaceNames>
        <EnablePublishedServerUriByRequest>false</EnablePublishedServerUriByRequest>
        <PublishedServerUriBySubnet />
        <RemoteIPFilter />
        <IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
      </NetworkConfiguration>
    '';
    owner = "jellyfin";
    path = "/var/lib/jellyfin/config/network.xml";
  };

  systemd.services.jellyfin-pfx = {
    description = "Generate Jellyfin PFX certificate";
    wantedBy = [ "multi-user.target" ];
    before = [ "jellyfin.service" ];
    after = [ "sops-nix.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "jellyfin";
      Group = "jellyfin";
      RemainAfterExit = true;
    };
    restartTriggers = [
      config.sops.secrets."jellyfin_key.pem".path
      config.sops.secrets."jellyfin_cert.pem".path
    ];
    script = ''
      mkdir -p /var/lib/jellyfin/ssl
      PASSWORD=$(cat ${config.sops.secrets.jellyfin-cert-pass.path})
      ${pkgs.openssl}/bin/openssl pkcs12 -export \
        -out /var/lib/jellyfin/ssl/jellyfin.pfx \
        -inkey ${config.sops.secrets."jellyfin_key.pem".path} \
        -in ${config.sops.secrets."jellyfin_cert.pem".path} \
        -certpbe PBE-SHA1-3DES \
        -keypbe PBE-SHA1-3DES \
        -macalg sha1 \
        -passout "pass:$PASSWORD"
    '';
  };

  networking.firewall = {
    extraCommands = ''
      iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8096
      iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8920
    '';

    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };

}
