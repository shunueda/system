{
  flake,
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.direnv-instant.homeModules.direnv-instant
    inputs.nocommit.homeModules.default
    inputs.sops-nix.homeManagerModules.sops
    flake.homeModules.ghq
    flake.modules.common.nixpkgs-unstable
  ];
  xdg.enable = true;
  programs = {
    # keep-sorted start block=yes
    bash = {
      enable = true;
      shellOptions = [
        "globstar"
        "histreedit"
        "extglob"
      ];
      historyControl = [
        "ignorespace"
        "ignoredups"
      ];
      historySize = 1000000;
      historyFileSize = 1000000;
      historyFile = "${config.home.homeDirectory}/.sh_history";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    direnv-instant.enable = true;
    emacs = {
      enable = true;
      extraPackages =
        epkgs: with epkgs; [
          avy
          corfu
          (direnv.overrideAttrs (prev: {
            patches = (prev.patches or [ ]) ++ [ ../../patches/emacs-direnv.patch ];
          }))
          exec-path-from-shell
          fzf
          git-gutter
          ghq
          magit
          nix-ts-mode
          ocaml-eglot
          smartparens
          treesit-grammars.with-all-grammars
          tuareg
          undo-tree
          vertico
          zenburn-theme
          flake.packages.${system}.majutsu
        ];
    };
    fzf.enable = true;
    ghq = {
      enable = true;
      settings = {
        root = "${config.home.homeDirectory}/code";
      };
    };
    home-manager.enable = true;
    jujutsu = {
      enable = true;
      package = pkgs-unstable.jujutsu;
      settings.user = {
        name = "Shun Ueda";
        email = "me@shu.nu";
      };
    };
    mergiraf.enable = true;
    nocommit.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$git_branch:$directory $character ";
        character = {
          format = "[\\$](white)";
        };
        directory = {
          format = "[$path]($style)";
          style = "bold blue";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bold green";
        };
      };
    };
    zoxide.enable = true;
    # keep-sorted end
  };
  fonts.fontconfig.enable = true;
  home = {
    packages =
      (with pkgs; [
        age
        gnupg
        jetbrains-mono
        nix-diff
        sops
      ])
      ++ (with pkgs-unstable; [ lima ])
      ++ (with flake.packages.${system}; [
        homerow
        ensure-jupyter-no-output
      ]);
    file = {
      ".emacs.d" = {
        source = ../../.emacs.d;
        recursive = true;
      };
      ".hushlogin" = {
        text = "";
      };
    };
  };
}
