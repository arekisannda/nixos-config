{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (emacs30.override {
      withPgtk = true;
      withNativeCompilation = true;
      withTreeSitter = true;
    })

    (aspellWithDicts (dicts: with dicts; [ en en-computers ]))

    emacs-lsp-booster
    gnuplot
    mermaid-cli
  ];

  environment.sessionVariables = {
    LSP_USE_PLISTS = "true";
  };
}
