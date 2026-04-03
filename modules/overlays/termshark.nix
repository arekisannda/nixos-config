{
  super,
  wireshark-cli,
  lib,
}:

super.termshark.overrideAttrs {
  postFixup = ''
    wrapProgram $out/bin/termshark \
        --prefix PATH : ${lib.makeBinPath [ wireshark-cli ]} \
        --prefix PATH : /run/wrappers/bin
  '';
}
