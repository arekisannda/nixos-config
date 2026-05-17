{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    enableZshIntegration = false;
  };
}
