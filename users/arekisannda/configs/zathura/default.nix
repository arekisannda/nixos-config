{ nixpkgs-unstable, ... }:

{
  programs.zathura.enable = true;
  programs.zathura.package = nixpkgs-unstable.zathura;
  programs.zathura.extraConfig = "";
  programs.zathura.mappings = {
    "[normal] <Up>" = "navigate previous";
    "[normal] <Down>" = "navigate next";
    "<F11>" = "toggle_fullscreen";
  };
  programs.zathura.options = {
    database = "null";
    default-bg = "#1a1a1a";
    recolor = false;
    render-loading = false;
    open-first-page = true;

    pages-per-row = 1;
    first-page-column = 1;
    advance-pages-per-row = true;
    page-v-padding = 9999;
    page-h-padding = 9999;
    scroll-page-aware = true;
    scroll-full-overlap = 0;
    scroll-step = 9999;
    adjust-open = "best-fit";
    zoom-center = true;
    vertical-center = true;
    guioptions = "none";
    statusbar-h-padding = 0;
    statusbar-v-padding = 0;
  };
}
