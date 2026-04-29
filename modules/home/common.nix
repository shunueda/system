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
        self.homeModules.screen
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
        direnv = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/issues/507531
          package = pkgs.direnv.overrideAttrs (_: {
            doCheck = false;
          });
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
                src = inputs.emacs-direnv-async;
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
              kotlin-ts-mode
              tuareg
              multiple-cursors
              undo-tree
              vertico
              zenburn-theme
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
          settings = {
            user = {
              name = "Shun Ueda";
              email = "me@shu.nu";
            };
            remotes.origin.auto-track-bookmarks = "*";
            ui.merge-editor = "mergiraf";
            merge-tools = {
              mergiraf = {
                program = lib.getExe config.programs.mergiraf.package;
              };
            };
          };
        };
        mergiraf.enable = true;
        nocommit.enable = true;
        screen = {
          enable = true;
          screenrc = "";
        };
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
      fonts.fontconfig.enable = true;
      home = {
        packages =
          (with pkgs; [
            age
            gnupg
            maccy
            orbstack
            sops
            nixd
            # BRUH fix later im too lazy
            ((import inputs.nixpkgs-steam {
              config.allowUnfree = true;
              inherit system;
            }).steam
            )
          ])
          ++ (with self.packages.${system}; [
            homerow
            ensure-jupyter-no-output
          ])
          ++ (with inputs.nixpkgs-unstable.legacyPackages.${system}; [
            # Only build on unstable because of some ffmpeg-python issue
            jetbrains-mono
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
