{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      i3ipc
      argparse
    ]))
  ];
}
