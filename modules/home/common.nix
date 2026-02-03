{
  flake,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nocommit.homeModules.default
    flake.modules.home.homerow
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
    homerow.enable = true;
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
    stateVersion = "25.11";
    packages = with pkgs; [
      age
      gnupg
      jetbrains-mono
      maccy
      nixd
      ocamlPackages.ocaml-lsp
      sops
      typescript-language-server
    ];
    file = {
      ".emacs.d" = {
        source = ../../.emacs.d;
        recursive = true;
      };
      ".hushlogin" = {
        text = "";
      };
    };
    sessionVariables = {
      EDITOR = "emacs";
    };
  };
  sops = {
    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
    defaultSopsFile = ../../secrets.yaml;
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
