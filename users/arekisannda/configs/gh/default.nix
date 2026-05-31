{ pkgs, ... }:

{
  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = false;

    settings = {
      git_protocol = "ssh";
      prompt = "";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };

    extensions = [ ];
  };
}
