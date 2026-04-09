{ inputs, ... }:
{
  flake.homeModules.common =
    {
      self,
      pkgs,
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
        self.homeModules.ghq
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
              self.packages.${system}.majutsu
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
        jujutsu = {
          enable = true;
          package = inputs.nixpkgs-unstable.legacyPackages.${system}.jujutsu;
          settings.user = {
            name = "Shun Ueda";
            email = "me@shu.nu";
          };
        };
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
            orbstack
            sops
            nixd
          ])
          ++ (with self.packages.${system}; [
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
    };
}
