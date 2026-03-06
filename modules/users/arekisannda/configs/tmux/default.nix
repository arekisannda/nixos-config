{ config, pkgs, ... }:

let
  terminal = config.setup.terminal;
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = terminal.type;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    focusEvents = true;
    aggressiveResize = true;
    mouse = true;

    extraConfig = builtins.readFile ./tmux.conf;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.logging;
        extraConfig = ''
          set -g @logging-path "$HOME/.config/tmux/logs"
          set -g @screen-capture-path "$HOME/.config/tmux/captures"
          set -g @save-complete-history-path "$HOME/.config/tmux/saves"
        '';
      }
      tmuxPlugins.tmux-fzf
      tmuxPlugins.jump
    ];
  };
}
