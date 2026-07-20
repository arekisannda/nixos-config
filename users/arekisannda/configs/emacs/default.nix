{
  pkgs,
  nixpkgs-emacs,
  ...
}:

let
  packages = nixpkgs-emacs;
  inherit (packages) emacsPackagesFor callPackage;

  epkgs = emacsPackagesFor (
    packages.emacs30.override {
      withPgtk = true;
      withNativeCompilation = true;
      withTreeSitter = true;
    }
  );

  load-custom-packages = package: callPackage package { inherit epkgs; };

  # custom package structure:
  # <package-name> =
  #   (load-custom-packages (
  #     { epkgs }:
  #     epkgs.melpaBuild {
  #       pname, ename, version;
  #       src = fetchGit { };
  #       packageRequires = [ ];
  #     }
  #   )).overrideAttrs (previousAttrs: { });

  org-dev = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "org";
      ename = "org";
      version = "9.8";
      src = fetchGit {
        url = "https://code.tecosaur.net/tec/org-mode.git";
        ref = "dev";
        rev = "1ef59f0aa02e3cff40bae68b756a29bc2001739e";
      };
      packageRequires = [ ];
    }
  );

  edraw = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "edraw";
      ename = "edraw";
      version = "1.2.1";
      src = fetchGit {
        url = "git@github.com:misohena/el-easydraw.git";
        ref = "master";
        rev = "8007f50c1c1734325c47939904f486753c7dd8ee";
      };
      packageRequires = [ ];
    }
  );

  scad-dbus = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "scad-dbus";
      ename = "scad-dbus";
      version = "0.1.0";
      src = fetchGit {
        url = "git@github.com:Lenbok/scad-dbus.git";
        ref = "v0.1";
        rev = "143768dc769f74e5c5c396a75529bb17202f9e1a";
      };
      packageRequires = [
        epkgs.scad-mode
        epkgs.hydra
      ];
    }
  );

  lazytab = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "lazytab";
      ename = "lazytab";
      version = "0.1.0";
      src = fetchGit {
        url = "git@github.com:karthink/lazytab.git";
        ref = "master";
        rev = "1cc4969c81cfa5ca87db598417c4193ada1470e4";
      };
      packageRequires = [ epkgs.cdlatex ];
    }
  );

  eglot-booster = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "eglot-booster";
      ename = "eglot-booster";
      version = "0.1.0";
      src = fetchGit {
        url = "git@github.com:jdtsmith/eglot-booster.git";
        ref = "main";
        rev = "cab7803c4f0adc7fff9da6680f90110674bb7a22";
      };
      packageRequires = [ ];
    }
  );

  activities = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "activities";
      ename = "activities";
      version = "0.8.0";
      src = fetchGit {
        url = "git@github.com:alphapapa/activities.el.git";
        ref = "master";
        rev = "d735c0f2c714ac98248ee17d765bfa8310201d53";
      };
      packageRequires = [ epkgs.persist ];
    }
  );

  corfu-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "corfu";
      ename = "corfu";
      version = "2.5.0";
      src = fetchGit {
        url = "git@github.com:minad/corfu.git";
        ref = "2.5";
        rev = "2d7d5d25a9003077329d3469b64d81a60a629aba";
      };
      files = ''("*.el")'';
      packageRequires = [ epkgs.compat ];
    }
  );

  cape-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "cape";
      ename = "cape";
      version = "2.3.0";
      src = fetchGit {
        url = "git@github.com:minad/cape.git";
        ref = "2.3";
        rev = "a3f190328df26f89046b9bfd2ae0adb859c102bd";
      };
      packageRequires = [ epkgs.compat ];
    }
  );

  gptel-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "gptel";
      ename = "gptel";
      version = "0.9.9";
      src = fetchGit {
        url = "git@github.com:karthink/gptel.git";
        ref = "v0.9.9.4";
        rev = "d221329ee3aa0198ad51c003a8d94b2af3a72dce";
      };
      packageRequires = [
        epkgs.compat
        epkgs.transient
      ];
    }
  );

  acp-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "acp";
      ename = "acp";
      version = "0.12.2";
      src = fetchGit {
        url = "git@github.com:xenodium/acp.el.git";
        ref = "v0.12.2";
        rev = "c8ee1d7f70105fba8efa964ca63f38ca94a1e759";
      };
      packageRequires = [ ];
    }
  );

  shell-maker-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "shell-maker";
      ename = "shell-maker";
      version = "0.93.1";
      src = fetchGit {
        url = "git@github.com:xenodium/shell-maker.git";
        ref = "v0.93.1";
        rev = "43ee9e1862994cbaa89715d324edb7a424181f22";
      };
      packageRequires = [ ];
    }
  );

  agent-shell-latest = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "agent-shell";
      ename = "agent-shell";
      version = "0.55.1";
      src = fetchGit {
        url = "git@github.com:xenodium/agent-shell.git";
        ref = "v0.55.1";
        rev = "d354db516b6ce8ddc00461e547adc2bae3b07d9d";
      };
      packageRequires = [
        shell-maker-latest
        acp-latest
      ];
    }
  );

  diff-hl-stable = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "diff-hl";
      ename = "diff-hl";
      version = "1.10.0";
      src = fetchGit {
        url = "git@github.com:dgutov/diff-hl.git";
        ref = "1.10.0";
        rev = "57d9d4e3e17397bf178c3aa5c369b5edd24523e0";
      };
      packageRequires = [
        epkgs.cl-lib
      ];
    }
  );

  leetcode = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "leetcode";
      ename = "leetcode";
      version = "0.1.28";
      src = fetchGit {
        url = "git@github.com:arekisannda/leetcode.el.git";
        ref = "feature/use-question-list-v2";
        rev = "65313d6144b8d15bb42b2ca8e11c7e21f284d6fe";
      };
      packageRequires = [
        epkgs.aio
        epkgs.log4e
        epkgs.s
        epkgs.persist
      ];
    }
  );

  exercism-dev = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "exercism";
      ename = "exercism";
      version = "0.1.0";
      src = fetchGit {
        url = "git@github.com:arekisannda/exercism.el.git";
        ref = "main";
        rev = "5dfc236cc440d7084a5ce5240438a8f253c18327";
      };
      packageRequires = [ ];
    }
  );

  windex = load-custom-packages (
    { epkgs }:
    epkgs.melpaBuild {
      pname = "windex";
      version = "0.0.12";
      src = fetchGit {
        url = "git@github.com:arekisannda/emacs-windex.git";
        ref = "v0.0.12";
        rev = "4d5b058558a2d183c468f7aef0055aff4a63d75b";
      };
      packageRequires = [
        epkgs.posframe
      ];
    }
  );

  emacs = epkgs.overrideScope (
    self: super: rec {
      acp = acp-latest;
      activities = activities;
      agent-shell = agent-shell-latest;
      cape = cape-latest;
      corfu = corfu-latest;
      diff-hl = diff-hl-stable;
      exercism = exercism-dev;
      gptel = gptel-latest;
      leetcode = leetcode;
      org = org-dev;
      shell-maker = shell-maker-latest;
    }
  );
in
{
  home.packages = [
    (emacs.emacsWithPackages (
      epkgs: with epkgs; [
        (treesit-grammars.with-grammars (
          grammars: with pkgs.tree-sitter-grammars; [
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
          ]
        ))

        doom-themes
        doom-modeline

        a
        ace-window
        activities
        affe
        agent-shell
        aio
        auctex
        cape
        casual
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
        edraw
        eglot-booster
        eldoc-box
        embark
        embark-consult
        emojify
        envrc
        ess
        evil
        evil-args
        evil-collection
        evil-lion
        evil-matchit
        evil-mc
        evil-nerd-commenter
        evil-surround
        expreg
        flymake-clippy
        flymake-golangci
        flymake-ruff
        forge
        general
        ghostel
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
        lazytab
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
        pr-review
        prettier-js
        rainbow-delimiters
        rainbow-mode
        rfc-mode
        rmsbolt
        rust-mode
        scad-dbus
        scad-mode
        smartparens
        terraform-mode
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
        w3m
        windex
        writegood-mode
        writeroom-mode
        yasnippet
        yasnippet-capf
        yasnippet-snippets

      ]
    ))
  ];
}
