{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      (texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium

          collection-basic collection-bibtexextra collection-binextra
          collection-fontsextra collection-fontsrecommended collection-fontutils
          collection-formatsextra collection-langcjk collection-latex
          collection-latexextra collection-latexrecommended collection-luatex
          collection-mathscience collection-metapost collection-plaingeneric

          algorithms amsfonts amsmath bbm bbm-macros capt-of circuitikz cm
          cm-super dvipng dvisvgm hyperref latexmk luatexbase metafont pgfplots
          ulem wrapfig;
      })
    ];
}
