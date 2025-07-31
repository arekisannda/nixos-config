{ ... }:

{
  programs.fzf ={
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "rg --hidden --no-ignore -l ''";
    defaultOptions = [
      "--color=bg+:-1"
      "--ansi"
      "--layout=reverse"
      "-i"
      "--height=8"
      "--inline-info"
      "--bind alt-k:preview-up,alt-j:preview-down,ctrl-u:clear-query"
    ];
    historyWidgetOptions = [
      "--reverse"
      "--sort"
      "--height=8"
    ];
    fileWidgetOptions = [
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];
  };
}
