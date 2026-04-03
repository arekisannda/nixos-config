args:

{ ... }:

let
  inherit (builtins)
    readDir
    listToAttrs
    attrValues
    mapAttrs
    match
    ;

  overlaysDir = ../modules/overlays;
  overlays = readDir overlaysDir;

  # packagePath =
  #   package:
  #   "${overlaysDir}${if match ".*\\.nix$" name == null then "${package}/default.nix" else package}";

  # makeOverlay =
  #   { package, ... }:
  #   listToAttrs {
  #     name = package;
  #     value = self: super: { ${name} = self.callPackage (packagePath package) { }; };
  #   };

in
{
  flake.overlays.default =
    self: super:
    let
      makePackage =
        name: type:
        let
          pkgName =
            if type == "regular" && builtins.match ".*\\.nix$" name != null then
              builtins.replaceStrings [ ".nix" ] [ "" ] name
            else
              name;
        in
        {
          name = pkgName;
          value = self.callPackage (overlaysDir + "/${name}") { inherit super; };
        };
    in
    listToAttrs (attrValues (mapAttrs makePackage overlays));
}
