{ pkgs, ... }:

let
  lspx = self: super: { lspx = pkgs.callPackage ./lspx.nix { }; };

  swayrst = self: super: { swayrst = pkgs.callPackage ./swayrst.nix { }; };

  rass = self: super: { rass = pkgs.callPackage ./rass.nix { }; };
in
{
  nixpkgs.overlays = [
    lspx
    swayrst
    rass
  ];
}
