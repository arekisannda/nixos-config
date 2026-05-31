{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    settings = {
      core = {
        excludeFile = "$HOME/.config/git/ignores";
      };

      init = {
        defaultBranch = "main";
      };

      alias = {
        graph = "log --graph --decorate --oneline --abbrev-commit --all";
        graphloc = "log --graph --decorate --oneline --abbrev-commit";
        trace = "log --follow --";
        last-commit = "! git rev-parse HEAD | cut -c1-7";
        pushme = "! git push origin $(git branch --show-current)";
      };

      commit.gpgsign = true;
    };

    includes = [
      { path = "${config.xdg.configHome}/git/userconfig"; }
    ];

    lfs = {
      enable = true;
      package = pkgs.git-lfs;
    };

    ignores = [
      ".envrc"
      ".direnv"

      # python

      "**/__pycache__/*"

      # tmux
      "**/tmux/plugins/*"
      "**/tmux/logs/*"
      "**/tmux/saves/*"
      "**/tmux/captures/*"

      # emacs/latex/org
      ".remarks.org"
      "*.ltjruby"
      "*.aux"
      "*.log"
      "*.out"
      "*~"
      "**/#*#"

      # rust
      "**/target/*"

      # debugging
      "**/__debug_*"
    ];
  };
}
