{ inputs, ... }:
{
  flake.homeModules.common =
    {
      self,
      pkgs,
      config,
      lib,
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
        # TODO: remove after 26.05 release
        self.homeModules.screen
        self.homeModules.qutebrowser
      ];
      xdg.enable = true;
      programs = {
        # keep-sorted start block=yes
        alacritty = {
          enable = true;
          theme = "alabaster";
          settings = {
            window = {
              padding = {
                x = 10;
                y = 10;
              };
            };
            font = {
              normal = {
                family = "JetBrains Mono";
                style = "Regular";
              };
              size = 13;
            };
          };
        };
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
        difftastic.enable = true;
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        direnv-instant.enable = true;
        emacs = {
          enable = true;
          overrides = self: super: {
            direnv = super.direnv.overrideAttrs (_: {
              src = inputs.emacs-direnv-async;
            });
          };
          extraPackages =
            epkgs: with epkgs; [
              avy
              corfu
              direnv
              exec-path-from-shell
              fzf
              git-gutter
              ghq
              magit
              nix-ts-mode
              ocaml-eglot
              smartparens
              treesit-grammars.with-all-grammars
              kotlin-ts-mode
              tuareg
              paredit
              multiple-cursors
              undo-tree
              vertico
              zenburn-theme
              super-save
              markdown-mode
              self.packages.${system}.majutsu
            ];
        };
        fzf.enable = true;
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
              signingKey = "0CCE2D6849A8D4EF";
            };
            commit.gpgSign = true;
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
        gpg = {
          enable = true;
          scdaemonSettings = {
            disable-ccid = true;
          };
        };
        home-manager.enable = true;
        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "Shun Ueda";
              email = "me@shu.nu";
            };
            remotes.origin.auto-track-bookmarks = "*";
            ui = {
              # TODO: can remove at 26.05 release
              merge-editor = "mergiraf";
              # TODO: can remove at 26.05 release
              diff-formatter = [
                (lib.getExe config.programs.difftastic.package)
                "--color=always"
                "--sort-paths"
                "$left"
                "$right"
              ];
            };
            signing = {
              behavior = "own";
              backend = "gpg";
              key = "0CCE2D6849A8D4EF";
            };
            # TODO: can remove at 26.05 release
            merge-tools = {
              mergiraf.program = lib.getExe config.programs.mergiraf.package;
            };
            colors = {
              "diff token" = {
                underline = false;
              };
            };
          };
        };
        mergiraf.enable = true;
        nocommit.enable = true;
        password-store.enable = true;
        screen = {
          enable = true;
        };
        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "github.com" = {
              user = "git";
              identitiesOnly = false;
            };
          };
        };
        starship = {
          enable = true;
          # TODO: jujutsu when they support it.
          # https://github.com/starship/starship/issues/6076.
          settings = {
            add_newline = false;
            format = "$directory $character ";
            character = {
              format = "[\\$](white)";
            };
            directory = {
              format = "[$path]($style)";
              style = "bold blue";
            };
          };
        };
        zoxide.enable = true;
        # keep-sorted end
      };
      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          pinentry.package = pkgs.pinentry_mac;
          defaultCacheTtl = 600;
          maxCacheTtl = 7200;
        };
      };
      fonts.fontconfig.enable = true;
      home = {
        packages =
          (with pkgs; [
            maccy
            orbstack
            sops
            nixd
            steam
            jetbrains-mono
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
        gnupg.sshKeyPaths = [ ];
        defaultSopsFile = ../../secrets/default.yaml;
        secrets = { };
      };
    };
}
