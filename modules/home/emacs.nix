{ ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages =
      epkgs: with epkgs; [
        avy
        corfu
        editorconfig
        exec-path-from-shell
        fzf
        git-gutter
        magit
        nix-ts-mode
        ocaml-eglot
        treesit-grammars.with-all-grammars
        tuareg
        undo-tree
        vertico
        zenburn-theme
      ];
  };
}
