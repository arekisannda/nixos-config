{ config, ... }:

let
  gui = config.setup.gui.theme;

  version = "21.04";
  kvYaru = builtins.fetchTarball {
    url = "https://github.com/GabePoel/KvYaru-Colors/releases/download/${version}/KvYaru.Colors.${version}.tar.xz";
    sha256 = "0l03qmfks625as6im649k6ksryvqd2lsbq9vyg404mryki7qfdnv";
  };
in
{
  xdg.configFile = {
    "Kvantum/KvYaru-Grey".source = "${kvYaru}/KvYaru-Grey";
    "Kvantum/kvantum.kvconfig" = {
      force = true;
      text = ''
        [General]
        theme=KvYaru-GreyDark
      '';
    };
  };
}
