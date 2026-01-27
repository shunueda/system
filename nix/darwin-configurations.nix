{
  lib,
  self,
  inputs,
  ...
}:
{
  flake = {
    darwinConfigurations =
      let
        darwinModules =
          let
            user = "me";
            system = "aarch64-darwin";
          in
          {
            common =
              { pkgs, ... }:
              {
                imports = [
                  inputs.home-manager.darwinModules.home-manager
                  darwinModules.pin-nixpkgs
                ];
                nix = {
                  settings.experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  gc.automatic = true;
                };
                nixpkgs = {
                  hostPlatform = system;
                  config.allowUnfree = true;
                };
                users.knownUsers = [ user ];
                users.users.${user} = {
                  uid = 501;
                  home = "/Users/${user}";
                  shell = pkgs.bash;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                system = {
                  primaryUser = user;
                  stateVersion = 6;
                  defaults = {
                    LaunchServices.LSQuarantine = false;
                    NSGlobalDomain = {
                      AppleShowAllExtensions = true;
                      KeyRepeat = 1;
                      InitialKeyRepeat = 15;
                    };
                    dock = {
                      show-recents = false;
                      autohide = true;
                      orientation = "bottom";
                      tilesize = 32;
                    };
                  };
                  keyboard = {
                    enableKeyMapping = true;
                    remapCapsLockToControl = true;
                  };
                };
                programs = {
                  _1password.enable = true;
                };
                security.pam.services.sudo_local.touchIdAuth = true;
                home-manager.users.${user} =
                  { config, ... }:
                  {
                    imports = [
                      ../programs/homerow.nix
                      inputs.sops-nix.homeManagerModules.sops
                    ];
                    xdg.enable = true;
                    programs = {
                      # keep-sorted start block=yes
                      bash = {
                        enable = true;
                        historyControl = [
                          "ignorespace"
                          "ignoredups"
                        ];
                        historySize = 1000000;
                        historyFileSize = 1000000;
                      };
                      docker-cli.enable = true;
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
                        };
                        hooks.pre-commit = lib.getExe inputs.nocommit.packages.${system}.default;
                      };
                      home-manager.enable = true;
                      homerow.enable = true;
                      mergiraf.enable = true;
                      ssh = {
                        enable = true;
                        enableDefaultConfig = false;
                        matchBlocks = {
                          "*" = {
                            identityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
                          };
                          "github.com" = {
                            user = "git";
                          };
                          "codeberg.org" = {
                            user = "git";
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
                      username = user;
                      stateVersion = "25.11";
                      packages = with pkgs; [
                        age
                        gnupg
                        jetbrains-mono
                        maccy
                        orbstack
                        nixd
                        ocamlPackages.ocaml-lsp
                        sops
                        typescript
                        typescript-language-server
                      ];
                      file = {
                        ".emacs.d" = {
                          source = ../.emacs.d;
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
                      defaultSopsFile = ../secrets/example.yaml;
                      secrets.example_key = {
                        path = "${config.home.homeDirectory}/test.txt";
                      };
                    };
                  };
              };
            linux-builder =
              { lib, ... }:
              {
                nix = {
                  linux-builder = {
                    enable = true;
                    ephemeral = true;
                    systems = lib.platforms.linux;
                    config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
                    config.virtualisation.cores = 6;
                    config.virtualisation.memorySize = lib.mkForce 12000;
                    config.virtualisation.diskSize = lib.mkForce (100 * 1000);
                    maxJobs = 12;
                  };
                  settings.trusted-users = [ "@admin" ];
                };
              };
            pin-nixpkgs =
              { ... }:
              {
                system.configurationRevision = self.rev or self.dirtyRev or null;
                nix.registry.nixpkgs.to = {
                  type = "github";
                  owner = "nixos";
                  repo = "nixpkgs";
                  inherit (inputs.nixpkgs.sourceInfo) narHash rev;
                };
                nix.extraOptions = ''
                  flake-registry = ${inputs.flakeregistry}/flake-registry.json
                '';
              };
          };
      in
      {
        personal = inputs.nix-darwin.lib.darwinSystem {
          modules =
            with darwinModules;
            [ common ]
            ++ (
              { pkgs, ... }:
              {
                programs = {
                  _1password-gui.enable = true;
                };
                home-manager.users.${user} = {
                  home.packages = with pkgs; [ prismlauncher ];
                  programs = {
                    discord.enable = true;
                    ssh = {
                      matchBlocks = {
                        "oyasai.io" = {
                          user = "oyasai";
                        };
                      };
                    };
                  };
                };
              }
            );
        };
        anterior = inputs.nix-darwin.lib.darwinSystem {
          modules = with darwinModules; [
            common
            linux-builder
          ];
        };
      };
  };
}
