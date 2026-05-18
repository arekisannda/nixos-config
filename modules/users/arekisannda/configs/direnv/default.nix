{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    mise.enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
