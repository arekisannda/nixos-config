{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jellyfin-desktop
  ];

  services.jellyfin-mpv-shim = {
    enable = false;
    package = pkgs.jellyfin-mpv-shim;

    settings = {
      mpv_ext = true;
      script = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
    };
  };
}
