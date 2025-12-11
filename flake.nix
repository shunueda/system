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
      flake = false;
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
        { self, ... }:
        {
          flake = {
            darwinConfigurations = {
              personal = nix-darwin.lib.darwinSystem { modules = [ self.darwinModules.personal ]; };
              work = nix-darwin.lib.darwinSystem { modules = [ self.darwinModules.work ]; };
            };
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
                      settings.experimental-features = "nix-command flakes";
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
                        };
                        dock = {
                          show-recents = false;
                          launchanim = true;
                          mouse-over-hilite-stack = false;
                          orientation = "bottom";
                          tilesize = 32;
                        };
                        finder = {
                          _FXShowPosixPathInTitle = false;
                        };
                        trackpad = {
                          Clicking = true;
                          TrackpadThreeFingerDrag = true;
                        };
                      };
                      keyboard = {
                        enableKeyMapping = true;
                        remapCapsLockToControl = true;
                      };
                    };
                    security.pam.services.sudo_local.touchIdAuth = true;
                    home-manager.users.${user} = {
                      programs = {
                        home-manager.enable = true;
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
                        git = {
                          enable = true;
                          settings = {
                            init = {
                              defaultBranch = "master";
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
                            merge = {
                              conflictStyle = "diff3";
                              mergiraf = {
                                name = "mergiraf";
                                driver = ''
                                  mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L
                                '';
                              };
                            };
                          };
                          attributes = [ "* merge=mergiraf" ];
                          hooks.pre-commit = pkgs.runCommand "pre-commit" { } ''
                            cat ${nocommit}/pre-commit > $out
                            chmod +x $out
                          '';
                        };
                        gh = {
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
                              corfu
                              git-gutter
                              magit
                              nix-ts-mode
                              treesit-grammars.with-all-grammars
                              undo-tree
                              vertico
                            ]
                            ++ (with pkgs; [
                              typescript
                              typescript-language-server
                              nixd
                            ]);
                        };
                        firefox = {
                          enable = true;
                        };
                      };
                      fonts.fontconfig.enable = true;
                      home = {
                        username = user;
                        stateVersion = "25.11";
                        packages = with pkgs; [
                          mergiraf
                          jetbrains-mono
                          orbstack
                        ];
                        file = {
                          ".emacs.d" = {
                            source = ./emacs.d;
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
                    home-manager.users.${user} = {
                      home.packages = with pkgs; [
                      ];
                      programs.discord = {
                        enable = true;
                      };
                    };
                  };
                work =
                  { pkgs, ... }:
                  {
                    imports = [
                      self.darwinModules.base
                      self.darwinModules.linux-builder
                    ];
                    home-manager.users.${user} = {
                      home.packages = with pkgs; [ ];
                    };
                  };
                linux-builder =
                  { lib, ... }:
                  {
                    nix = {
                      linux-builder = {
                        enable = true;
                        ephemeral = true;
                        systems = [
                          "x86_64-linux"
                          "aarch64-linux"
                        ];
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
