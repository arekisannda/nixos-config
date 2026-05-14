{
  config,
  pkgs,
  lib,
  ...
}:

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

  home.activation.reloadTmux = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.tmux}/bin/tmux info &>/dev/null; then
      ${pkgs.tmux}/bin/tmux source-file ${config.xdg.configHome}/tmux/tmux.conf
      ${pkgs.libnotify}/bin/notify-send --transient -h "string:synchronous:tmux" -t 5000 "Home-Manager Activation" "Reload tmux configuration."
    fi
  '';
}
