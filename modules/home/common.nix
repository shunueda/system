{
  flake,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nocommit.homeModules.default
    flake.homeModules.ghq
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
    emacs = {
      enable = true;
      extraPackages =
        epkgs: with epkgs; [
          avy
          corfu
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
    fzf.enable = true;
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        auto-update = "off";
        link-previews = true;
        mouse-hide-while-typing = true;
        window-save-state = "always";
      };
    };
    ghq = {
      enable = true;
      settings = {
        root = "${config.home.homeDirectory}/code";
      };
    };
    git = {
      enable = true;
      settings = {
        init = {
          defaultBranch = "master";
        };
        user = {
          name = "Shun Ueda";
          email = "me@shu.nu";
        };
        diff.algorithm = "histogram";
        rebase = {
          autosquash = true;
          autostash = true;
          stat = true;
        };
        merge.directoryRenames = true;
        rerere = {
          autoupdate = true;
          enabled = true;
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
    home-manager.enable = true;
    mergiraf.enable = true;
    nocommit.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = config.sops.secrets.id_ed25519_github.path;
        };
      };
    };
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
        maccy
        nixd
        ocamlPackages.ocaml-lsp
        orbstack
        python313Packages.python-lsp-server
        sops
        typescript-language-server
      ])
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
  sops = {
    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ../../secrets/default.yaml;
    secrets = {
      id_ed25519_github = { };
      id_ed25519_oyasai = { };
    };
  };
  # https://github.com/Mic92/sops-nix/issues/890
  launchd.agents.sops-nix = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = pkgs.lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
