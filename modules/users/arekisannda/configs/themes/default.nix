{ ... }:

let
  version = "21.04";
  tag = "${version}snap";

  yaru = fetchTarball {
    url = "https://github.com/Jannomag/Yaru-Colors/archive/refs/tags/${tag}.tar.gz";
    sha256 = "1hraqbb726zh32ai2clxwlarpzsbw4iazvq151xs5rak3ik2cjvh";
    name = "yaru-gtk";
  };
in
{
  xdg.dataFile = {
    "themes/Yaru-Grey-dark".source = "${yaru}/Themes/Yaru-Grey-dark";
  };
}
