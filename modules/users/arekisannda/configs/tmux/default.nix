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

    extraConfig = ''
    set -ga terminal-overrides ',xterm*:Tc:smcup@:rmcup@'
    set -g display-time 4000

    # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
    set -g status-interval 5

    unbind -T prefix d
    unbind -T prefix \"
    unbind -T prefix \%
    
    bind-key -T prefix W choose-tree -Zw
    bind-key -T prefix S choose-tree -Zs
    bind-key -T prefix v split-pane -h
    bind-key -T prefix s split-pane
    bind-key -T prefix \+ setw synchronize-panes
    bind-key -T prefix C-s command-prompt -p "Swap with pane:" "swap-pane -t '%%'"
    
    bind-key -T root C-Up    select-pane -U
    bind-key -T root C-Down  select-pane -D
    bind-key -T root C-Left  select-pane -L
    bind-key -T root C-Right select-pane -R
  '';

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


