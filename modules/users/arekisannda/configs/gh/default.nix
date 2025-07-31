{ pkgs, ... }:

{
  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
    
    extensions = with pkgs; [];
  };
}
