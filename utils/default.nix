{ ... }:

let
  stringToChars = str: builtins.filter builtins.isString (builtins.split "" str);

  fromBase =
    base: digits: str:
    let
      chars = builtins.filter (c: c != "") (stringToChars str);
    in
    builtins.foldl' (acc: c: acc * base + digits.${c}) 0 chars;

  binDigits = {
    "0" = 0;
    "1" = 1;
  };
  octDigits = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
  };
  hexDigits = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };
in
{
  binToInt = fromBase 2 binDigits;
  octToInt = fromBase 8 octDigits;
  hexToInt = fromBase 16 hexDigits;
}
