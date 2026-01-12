{ lib, libnotify, stdenv, }:

stdenv.mkDerivation rec {
  pname = "mpv-notify-send";
  version = "0.0.1-custom";

  src = ./lua/notify-send.lua;

  dontBuild = true;
  dontUnpack = true;

  passthru.extraWrapperArgs =
    [ "--prefix" "PATH" ":" (lib.makeBinPath [ libnotify ]) ];

  installPhase = ''
    install -Dm644 ${src} $out/share/mpv/scripts/notify-lua.lua
  '';

  passthru.scriptName = "notify-lua.lua";
}

