{ ... }:

let
  colors = import ./colors.nix;
  radix = import ./radix.nix;
in
{
  inherit colors radix;
}
