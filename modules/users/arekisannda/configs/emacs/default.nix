{ pkgs, nixpkgs-emacs, ... }:

let
  emacs = (nixpkgs-emacs.emacs30.override {
    withPgtk = true;
    withNativeCompilation = true;
    withTreeSitter = true;
  });

  load-custom-packages = package:
    nixpkgs-emacs.callPackage package { epkgs = nixpkgs-emacs.emacsPackages; };

  org-dev = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "org";
      ename = "org";
      version = "9.8";
      src = builtins.fetchGit {
        url = "https://code.tecosaur.net/tec/org-mode.git";
        ref = "dev";
        rev = "f9f909681a051c73c64cc7b030aa54d70bb78f80";
      };
      packageRequires = [ ];
    });

  org-typst-preview = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "org-typst-preview";
      ename = "org-typst-preview";
      version = "0.1.0";
      src = builtins.fetchGit {
        url = "git@github.com:remimimimimi/org-typst-preview.el.git";
        ref = "main";
        rev = "de334cf3daa84b23ceea2a9fc70b6787f7c6af5b";
      };
      packageRequires = [ ];
    });

  edraw = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "edraw";
      ename = "edraw";
      version = "1.2.1";
      src = builtins.fetchGit {
        url = "git@github.com:misohena/el-easydraw.git";
        ref = "master";
        rev = "8007f50c1c1734325c47939904f486753c7dd8ee";
      };
      packageRequires = [ ];
    });

  scad-dbus = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "scad-dbus";
      ename = "scad-dbus";
      version = "0.1.0";
      src = builtins.fetchGit {
        url = "git@github.com:Lenbok/scad-dbus.git";
        ref = "v0.1";
        rev = "143768dc769f74e5c5c396a75529bb17202f9e1a";
      };
      packageRequires = [ epkgs.scad-mode epkgs.hydra ];
    });

  lazytab = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "lazytab";
      ename = "lazytab";
      version = "0.1.0";
      src = builtins.fetchGit {
        url = "git@github.com:karthink/lazytab.git";
        ref = "master";
        rev = "1cc4969c81cfa5ca87db598417c4193ada1470e4";
      };
      packageRequires = [ epkgs.cdlatex ];
    });

  eglot-booster = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "eglot-booster";
      ename = "eglot-booster";
      version = "0.1.0";
      src = builtins.fetchGit {
        url = "git@github.com:jdtsmith/eglot-booster.git";
        ref = "main";
        rev = "cab7803c4f0adc7fff9da6680f90110674bb7a22";
      };
      packageRequires = [ ];
    });

  exercism = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "exercism";
      ename = "exercism";
      version = "0.1.0";
      src = builtins.fetchGit {
        url = "git@github.com:arekisannda/exercism.el.git";
        ref = "main";
        rev = "5dfc236cc440d7084a5ce5240438a8f253c18327";
      };
      packageRequires = [ ];
    });

  activities = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "activities";
      ename = "activities";
      version = "0.8.0";
      src = builtins.fetchGit {
        url = "git@github.com:alphapapa/activities.el.git";
        ref = "master";
        rev = "d735c0f2c714ac98248ee17d765bfa8310201d53";
      };
      packageRequires = [ epkgs.persist ];
    });

  windex = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "windex";
      version = "0.0.7";
      src = builtins.fetchGit {
        url = "git@github.com:arekisannda/emacs-windex.git";
        ref = "v0.0.7";
        rev = "7923a015285a5c3e58db2a53a71d84f18ff45c9b";
      };
      packageRequires = [ epkgs.posframe ];
    });

  doom-code-review = (load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "code-review";
      ename = "code-review";
      version = "0.0.8";
      src = builtins.fetchGit {
        url = "git@github.com:doomelpa/code-review.git";
        ref = "master";
        rev = "303edcfbad8190eccb9a9269dfc58ed26d386ba5";
      };

      packageRequires = [
        epkgs.a
        epkgs.closql
        epkgs.deferred
        epkgs.emojify
        epkgs.forge
        epkgs.ghub
        epkgs.magit
        epkgs.markdown-mode
        epkgs.transient
        epkgs.uuidgen
      ];
    })).overrideAttrs (previousAttrs: {
      nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ]
        ++ [ pkgs.git ];
    });

  corfu-latest = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "corfu";
      ename = "corfu";
      version = "2.5.0";
      src = builtins.fetchGit {
        url = "git@github.com:minad/corfu.git";
        ref = "2.5";
        rev = "2d7d5d25a9003077329d3469b64d81a60a629aba";
      };
      files = ''("*.el")'';
      packageRequires = [ epkgs.compat ];
    });

  cape-latest = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "cape";
      ename = "cape";
      version = "2.3.0";
      src = builtins.fetchGit {
        url = "git@github.com:minad/cape.git";
        ref = "2.3";
        rev = "a3f190328df26f89046b9bfd2ae0adb859c102bd";
      };
      packageRequires = [ epkgs.compat ];
    });

  leetcode-latest = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "leetcode";
      ename = "leetcode";
      version = "0.1.28";
      src = builtins.fetchGit {
        url = "git@github.com:kaiwk/leetcode.el.git";
        ref = "v0.1.28";
        rev = "02eb6ff9c75ba8f0a7196f34665e9ed43c4d7598";
      };
      packageRequires = [ epkgs.aio epkgs.log4e epkgs.s ];
    });

  gptel-latest = load-custom-packages ({ epkgs }:
    epkgs.melpaBuild {
      pname = "gptel";
      ename = "gptel";
      version = "0.9.9";
      src = builtins.fetchGit {
        url = "git@github.com:karthink/gptel.git";
        ref = "v0.9.9.3";
        rev = "d0c392bbb0a1f7775d3a1e98220f4bdc043ab63b";
      };
      packageRequires = [ epkgs.compat epkgs.transient ];
    });

in {
  programs.emacs = {
    enable = true;

    package = emacs;

    extraPackages = epkgs:
      with epkgs; [
        (treesit-grammars.with-grammars (grammars:
          with pkgs.tree-sitter-grammars; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-c-sharp
            tree-sitter-cmake
            tree-sitter-css
            tree-sitter-cpp
            tree-sitter-dockerfile
            tree-sitter-elisp
            tree-sitter-go
            tree-sitter-gomod
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-kotlin
            tree-sitter-latex
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-typst
            tree-sitter-yaml
          ]))

        doom-themes
        doom-modeline

        a
        ace-window
        activities
        affe
        aio
        auctex
        cape
        cdlatex
        closql
        compat
        consult
        consult-dir
        consult-eglot
        corfu
        dape
        dashboard
        deferred
        detached
        devdocs
        diff-hl
        diminish
        editorconfig
        eldoc-box
        embark
        embark-consult
        embrace
        emojify
        envrc
        ess
        evil
        evil-args
        evil-collection
        evil-easymotion
        evil-lion
        evil-matchit
        evil-mc
        evil-nerd-commenter
        evil-snipe
        flymake-clippy
        flymake-golangci
        flymake-ruff
        forge
        general
        ghub
        gnuplot
        gnuplot-mode
        go-mode
        google-translate
        gptel
        helpful
        hydra
        i3wm-config-mode
        ibuffer-project
        impatient-mode
        indent-bars
        kotlin-mode
        kotlin-ts-mode
        latex-math-preview
        latex-preview-pane
        leetcode
        magit
        marginalia
        markdown-mode
        mermaid-mode
        meson-mode
        nerd-icons
        nerd-icons-corfu
        nix-mode
        nix-ts-mode
        no-littering
        ob-go
        ob-kotlin
        ob-mermaid
        ob-rust
        ob-typescript
        orderless
        org
        org-contrib
        org-download
        org-modern
        org-remark
        org-roam
        org-roam-ui
        org-super-agenda
        pdf-tools
        persist
        plantuml-mode
        posframe
        prettier-js
        rainbow-delimiters
        rainbow-mode
        rfc-mode
        rmsbolt
        rust-mode
        scad-mode
        shackle
        tmux-mode
        transient
        treemacs
        treemacs-evil
        treemacs-nerd-icons
        treemacs-tab-bar
        treesit-fold
        typescript-mode
        typst-ts-mode
        undo-fu
        uuidgen
        valign
        vertico
        vertico-posframe
        vterm
        w3m
        windex
        writegood-mode
        writeroom-mode
        yasnippet
        yasnippet-capf
        yasnippet-snippets

        # custom packages
        org-typst-preview
        edraw
        eglot-booster
        lazytab
        scad-dbus
        code-review
      ];

    overrides = self: super: rec {
      org = org-dev;
      activities = activities;
      code-review = doom-code-review;
      corfu = corfu-latest;
      cape = cape-latest;
      leetcode = leetcode-latest;
      gptel = gptel-latest;
    };
  };
}
