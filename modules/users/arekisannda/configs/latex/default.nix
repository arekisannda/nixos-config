{ pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-medium

        collection-basic
        collection-bibtexextra
        collection-binextra
        collection-fontsextra
        collection-fontsrecommended
        collection-fontutils
        collection-formatsextra
        collection-langcjk
        collection-latex
        collection-latexextra
        collection-latexrecommended
        collection-luatex
        collection-mathscience
        collection-metapost
        collection-plaingeneric

        algorithms
        amsfonts
        amsmath
        bbm
        bbm-macros
        capt-of
        circuitikz
        cm
        cm-super
        dvipng
        dvisvgm
        haranoaji
        hyperref
        latexmk
        luatexbase
        metafont
        pgfplots
        ulem
        wrapfig
      ;};
  };
}
