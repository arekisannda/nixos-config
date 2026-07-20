let
  radix = import ./radix.nix;

  inherit (builtins) substring floor elemAt;
  inherit (radix) hexToInt intToHex;

  hexColorRegex = "#([0-9a-f]{6})";
  patternMatch = pattern: str: builtins.match pattern str != null;
  isColor =
    hexColor:
    if !(patternMatch hexColorRegex hexColor) then (throw "Invalid hex color string") else true;

  abs = x: if x < 0 then -x else x;
  min = a: b: (a + b - abs (a - b)) / 2;
  max = a: b: (a + b + abs (a - b)) / 2;
  clampColorValue = color: max 0 (min 255 color);

  padLeft =
    width: char: s:
    let
      len = builtins.stringLength s;
    in
    if len >= width then
      s
    else
      (builtins.concatStringsSep "" (builtins.genList (_: char) (width - len))) + s;

  hexToRgb =
    hexColor:
    let
      hex = substring 1 (-1) hexColor;
    in
    [
      ((hexToInt (substring 0 2 hex)) / 255.0)
      ((hexToInt (substring 2 2 hex)) / 255.0)
      ((hexToInt (substring 4 2 hex)) / 255.0)
    ];

  toHexColor = x: padLeft 2 "0" (intToHex (floor (x * 255)));

  blend =
    color1: color2: alpha:
    let
      c1 = hexToRgb color1;
      c2 = hexToRgb color2;

      res = builtins.genList (i: (((elemAt c1 i) * 1.0 * alpha) + ((elemAt c2 i) * (1.0 - alpha)))) 3
      ;
    in
    if (isColor color1) && (isColor color2) && (builtins.isFloat alpha) then
      "#" + (toHexColor (elemAt res 0)) + (toHexColor (elemAt res 1)) + (toHexColor (elemAt res 2))
    else
      color1;

  lighten = color: alpha: (blend color "#ffffff" (1.0 - alpha));

  darken = color: alpha: (blend color "#000000" (1.0 - alpha));
in
{
  inherit
    blend
    lighten
    darken ;
}
