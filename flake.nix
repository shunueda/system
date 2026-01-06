{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flakeregistry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nocommit = {
      url = "github:nobssoftware/nocommit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
  };
  outputs =
    {
      nixpkgs,
      nix-darwin,
      nix-index-database,
      home-manager,
      flake-parts,
      flakeregistry,
      nocommit,
      ...
    }@inputs:
    let
      flakeAllSystems =
        { self, lib, ... }:
        {
          flake = {
            darwinConfigurations = lib.mapAttrs (
              name: module: nix-darwin.lib.darwinSystem { modules = [ module ]; }
            ) self.darwinModules;
            darwinModules =
              let
                user = "me";
                system = "aarch64-darwin";
              in
              {
                base =
                  { pkgs, ... }:
                  {
                    imports = [
                      home-manager.darwinModules.home-manager
                      nix-index-database.darwinModules.nix-index
                      self.darwinModules.pin-nixpkgs
                    ];
                    programs.nix-index-database.comma.enable = true;
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
                    users.users.${user}.home = "/Users/${user}";
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
                      _1password = {
                        enable = true;
                      };
                    };
                    security.pam.services.sudo_local.touchIdAuth = true;
                    home-manager.users.${user} = {
                      imports = [ ./programs/homerow.nix ];
                      programs = {
                        home-manager.enable = true;
                        homerow = {
                          enable = true;
                        };
                        zsh = {
                          enable = true;
                          enableCompletion = true;
                          autosuggestion.enable = true;
                          syntaxHighlighting.enable = true;
                          oh-my-zsh = {
                            enable = true;
                            plugins = [ ];
                            theme = "robbyrussell";
                          };
                        };
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
                            "oyasai.io" = {
                              user = "oyasai";
                            };
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
                            rerere = {
                              autoupdate = true;
                              enabled = true;
                            };
                          };
                          hooks.pre-commit = "${lib.getExe nocommit.packages.${system}.default}";
                        };
                        mergiraf = {
                          enable = true;
                        };
                        docker-cli = {
                          enable = true;
                        };
                        emacs = {
                          enable = true;
                          package = pkgs.emacs;
                          extraPackages =
                            epkgs:
                            with epkgs;
                            [
                              avy
                              corfu
                              editorconfig
                              git-gutter
                              magit
                              nix-ts-mode
                              ocaml-eglot
                              treesit-grammars.with-all-grammars
                              tuareg
                              undo-tree
                              vertico
                              vterm
                            ]
                            ++ (with pkgs; [
                              nixd
                              ocamlPackages.ocaml-lsp
                              typescript
                              typescript-language-server
                            ]);
                        };
                      };
                      fonts.fontconfig.enable = true;
                      home = {
                        username = user;
                        stateVersion = "25.11";
                        packages = with pkgs; [
                          jetbrains-mono
                          maccy
                          orbstack
                          yabai
                        ];
                        file = {
                          ".emacs.d" = {
                            source = ./.emacs.d;
                            recursive = true;
                          };
                        };
                      };
                    };
                  };
                personal =
                  { pkgs, ... }:
                  {
                    imports = [ self.darwinModules.base ];
                    programs = {
                      _1password-gui = {
                        enable = true;
                      };
                    };
                    home-manager.users.${user} = {
                      home.packages = with pkgs; [ prismlauncher ];
                      programs = {
                        discord = {
                          enable = true;
                        };
                      };
                    };
                  };
                anterior =
                  { ... }:
                  {
                    imports = [
                      self.darwinModules.base
                      self.darwinModules.linux-builder
                    ];
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
                      inherit (nixpkgs.sourceInfo) narHash rev;
                    };
                    nix.extraOptions = ''
                      flake-registry = ${flakeregistry}/flake-registry.json
                    '';
                  };
              };
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      imports = [
        ./nix/treefmt.nix
        inputs.treefmt-nix.flakeModule
        flakeAllSystems
      ];
    };
}
